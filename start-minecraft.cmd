@echo off
setlocal
cd /d "%~dp0" || exit /b 1

"%~dp0java\bin\java.exe" -Xms1G -Xmx2G -jar "%~dp0server.jar" nogui
set "serverExitCode=%ERRORLEVEL%"

if not "%serverExitCode%"=="0" pause
exit /b %serverExitCode%
