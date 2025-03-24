@ECHO OFF

SETLOCAL ENABLEDELAYEDEXPANSION

SET ARGS=
FOR %%A IN (%*) DO (
    SET ARGS=!ARGS! ""%%~A""
)
SET ARGS=!ARGS:~1!

START /B mshta vbscript:CreateObject(^"WScript.Shell^").Run(^"!ARGS!^",0)(window.close)

SETLOCAL DISABLEDELAYEDEXPANSION