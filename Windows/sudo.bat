@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

SET ARGS=
FOR %%A IN (%*) DO (
    SET ARGS=!ARGS! ""%%~A""
)

START /B mshta vbscript:CreateObject(^"Shell.Application^").ShellExecute(^"CMD^",^"/C START ^"^"^"^" /D ^"^"%CD%^"^" /B !ARGS!^",^"%CD%^",^"runas^",1)(window.close)

SETLOCAL DISABLEDELAYEDEXPANSION
