@ECHO OFF

IF NOT "%1"=="BACKGROUND" (
    GOTO BACKGROUND
)

SHIFT /1
GOTO MAIN


:BACKGROUND

SETLOCAL ENABLEDELAYEDEXPANSION

SET ARGS=
FOR %%A IN (%*) DO (
    SET ARGS=!ARGS! ""%%~A""
)

START /B mshta vbscript:CreateObject(^"WScript.Shell^").Run(^"^"^"%~dpnx0^"^" BACKGROUND !ARGS!^",0)(window.close)

SETLOCAL DISABLEDELAYEDEXPANSION

GOTO END

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::
@REM This is the main function code part, with two necessary labels :MAIN and :END

:MAIN   @REM The Entrance of the Main Function

SET ARGS=%*
>bg-log.txt ECHO Args: %ARGS:~12%
>>bg-log.txt ECHO.
>>bg-log.txt ping -n 8 -a www.baidu.com

:END    @REM The Exit of the Main Function
EXIT %ERRORLEVEL%