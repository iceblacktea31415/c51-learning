<#
.SYNOPSIS
    按工程文件夹名自动设置 EIDE 工程名（并换新 uid）。

.DESCRIPTION
    从文件夹名开头识别 "数字-数字" 形式的项目编号，例如：
        "3-2 独立按键控制LED状态"  ->  工程名 p3_2  ->  产物 p3_2.hex
    同时给 .eide\eide.yml 换一个新的 uid，避免和复制来源的工程撞 id，
    并把 *.code-workspace 文件改名为 <工程名>.code-workspace。

.PARAMETER ProjectDir
    工程文件夹路径。省略时使用当前所在目录。

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File eide_rename_by_folder.ps1 "D:\Keil_project\3-2 独立按键控制LED状态"

.NOTES
    运行前务必先关闭 VSCode 里打开的那个工程窗口，
    否则 EIDE 会用内存里的旧配置把本脚本的修改覆盖掉。
#>
param(
    [string]$ProjectDir = ''
)

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = (Get-Location).Path
}

$ProjectDir = (Resolve-Path -LiteralPath $ProjectDir).Path
$yml = Join-Path $ProjectDir '.eide\eide.yml'

if (-not (Test-Path -LiteralPath $yml)) {
    Write-Host "错误：找不到 $yml" -ForegroundColor Red
    Write-Host "      请把工程文件夹路径传给脚本，或在工程目录里运行。" -ForegroundColor Red
    exit 1
}

$leaf = Split-Path -Leaf $ProjectDir
$newName = ''

if ($leaf -match '^\s*(\d+)\s*[-_]\s*(\d+)') {
    $newName = 'p' + $Matches[1] + '_' + $Matches[2]
} else {
    Write-Host "提示：文件夹名 '$leaf' 里没有 '数字-数字' 形式的编号，工程名保持不变。" -ForegroundColor Yellow
}

$text = [System.IO.File]::ReadAllText($yml, [System.Text.Encoding]::UTF8)
$newUid = [guid]::NewGuid().ToString('N')

if ($newName -ne '') {
    if ([regex]::IsMatch($text, '(?m)^name:.*$')) {
        $text = [regex]::Replace($text, '(?m)^name:.*$', "name: $newName")
    } else {
        $text = "name: $newName" + [Environment]::NewLine + $text
    }
}

$text = [regex]::Replace($text, '(?m)^(\s*)uid:.*$', '${1}uid: ' + $newUid)

$enc = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($yml, $text, $enc)

if ($newName -ne '') {
    $oldWs = Get-ChildItem -LiteralPath $ProjectDir -Filter '*.code-workspace' -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $oldWs) {
        $targetWs = Join-Path $ProjectDir ($newName + '.code-workspace')
        if ($oldWs.FullName -ne $targetWs) {
            if (Test-Path -LiteralPath $targetWs) {
                Write-Host "提示：目标 workspace 文件已存在，跳过改名。" -ForegroundColor Yellow
            } else {
                Rename-Item -LiteralPath $oldWs.FullName -NewName ($newName + '.code-workspace')
                Write-Host ("workspace 文件已改名为 " + $newName + ".code-workspace")
            }
        }
    }
}

Write-Host ""
Write-Host ("文件夹  : " + $leaf)
Write-Host ("工程名  : " + $newName)
Write-Host ("新 uid  : " + $newUid)
Write-Host ("配置文件: " + $yml)
Write-Host ""
Write-Host ("下一步：重新打开工程并构建，产物为 " + $newName + ".hex")
Write-Host  "        旧 build\Debug 里的历史产物不会自动消失，可按需清理。"
