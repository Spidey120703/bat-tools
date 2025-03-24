@ECHO OFF

>NUL 2>&1 OPENFILES

IF ERRORLEVEL 1 (
    GOTO UAC
)

GOTO MAIN


:UAC

SETLOCAL ENABLEDELAYEDEXPANSION

SET ARGS=
FOR %%A IN (%*) DO (
    SET ARGS=!ARGS! ""%%~A""
)

START /B mshta vbscript:CreateObject(^"Shell.Application^").ShellExecute(^"CMD^",^"/C START ^"^"^"^" /D ^"^"%CD%^"^" /B ^"^"%~dpnx0^"^" !ARGS!^",^"%CD%^",^"runas^",1)(window.close)

SETLOCAL DISABLEDELAYEDEXPANSION

GOTO END

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::
@REM This is the main function code part, with two necessary labels :MAIN and :END

:MAIN   @REM The Entrance of the Main Function

REM Main Function Here
ECHO.
ECHO [INFO] This script is running as Administrator by User Account Control...
ECHO.
ECHO [INFO] Command Line: %0 %*
ECHO.
PAUSE


:END    @REM The Exit of the Main Function
EXIT /B 0