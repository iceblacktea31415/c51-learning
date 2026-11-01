@echo off
setlocal
rem Rename EIDE project according to its folder name.
rem Usage 1: drag the project folder onto this .bat file.
rem Usage 2: double click this .bat and paste the folder path.
set "TARGET=%~1"
set "SCRIPT="

if exist "%~dp0eide_rename_by_folder.ps1" set "SCRIPT=%~dp0eide_rename_by_folder.ps1"
if not defined SCRIPT if exist "D:\Keil_project\_tools\eide_rename_by_folder.ps1" set "SCRIPT=D:\Keil_project\_tools\eide_rename_by_folder.ps1"
if not defined SCRIPT if exist "D:\Keil_project\eide_rename_by_folder.ps1" set "SCRIPT=D:\Keil_project\eide_rename_by_folder.ps1"

if "%TARGET%"=="" set /p TARGET=Project folder path: 
set "TARGET=%TARGET:"=%"

if "%TARGET%"=="" goto :end
if not defined SCRIPT echo [ERROR] eide_rename_by_folder.ps1 not found & goto :end

echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" -ProjectDir "%TARGET%"

:end
echo.
pause
