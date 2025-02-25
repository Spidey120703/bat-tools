@echo off
if "%1"=="uac" goto main
sudo clean.bat uac
exit
:main
del /f /s /q %localappdata%\CrashDumps\*
del /f /s /q C:\Windows\System32\config\systemprofile\AppData\Local\CrashDumps\*
del /f /s /q %windir%\SoftwareDistribution\Download\*
rem del /f /s /q %temp%\*
del /f /s /q %temp%\vscode-stable-user-x64
del /f /s /q %appdata%\Code\CachedExtensionVSIXs\*
del /f /s /q %appdata%\Code\Crashpad\reports\*
del /f /s /q %localappdata%\Microsoft\vscode-cpptools\*
pause