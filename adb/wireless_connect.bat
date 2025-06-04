@echo off

setlocal enabledelayedexpansion

if exist address.txt (
	<address.txt set /p old_address=
) else (
	set old_address=
)

if not "!old_address!"=="" (
    goto has_old_address
) else (
    goto has_no_old_address
)

:connecting

echo.
for /f "tokens=4" %%c in ('chcp') do (set old_chcp=%%c)
>nul chcp 65001

> address.txt echo.!address!
adb connect !address! 2>&1 | findstr cannot

set adb_ret=!errorlevel!

goto end

@REM ----------------------------------------------------------------------------------------------------

:has_old_address

set /p address=[*] Please input the address of the Android device [!old_address!]: 
if "!address!"=="" (
    set address=!old_address!
)

goto connecting


@REM ----------------------------------------------------------------------------------------------------

:has_no_old_address

set /p address=[*] Please input the address of the Android device: 
if "!address!"=="" (
    goto has_no_old_address
)

goto connecting

@REM ----------------------------------------------------------------------------------------------------

:end

if !adb_ret!==0 (
    echo.
    echo [-] Please connect the device with USB cable before continuing.
    pause
    echo.
    adb tcpip 5555 | findstr cannot
    if !errorlevel!==1 (
        echo.
        echo [-] Failed to start the wireless debugger port, please check before continuing.
        pause
    )
    echo.
    call "%0"
)

>nul chcp !old_chcp!
setlocal disabledelayedexpansion
