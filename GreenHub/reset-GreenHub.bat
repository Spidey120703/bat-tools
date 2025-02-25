@ECHO OFF

FOR /F "usebackq delims==" %%i in (`wmic process where caption^='GreenHub.exe' get ExecutablePath ^| findstr GreenHub.exe`) DO @(
  SET GREEN_HUB_EXECUTABLE_PATH=%%i
	
	REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /V ProxyEnable /T REG_DWORD /D 0x0 /F
	TASKKILL /T /F /IM "GreenHub.exe"

	:: RMDIR /S /Q "%APPDATA%\GreenHub"
	CHCP 65001
	REM CALL "%GREEN_HUB_EXECUTABLE_PATH%"
	CALL "C:\Users\Public\Desktop\GreenHub.lnk"

  goto :EOF
)

:: RMDIR /S /Q "%APPDATA%\GreenHub"
CALL "C:\Users\Public\Desktop\GreenHub.lnk"

:EOF
