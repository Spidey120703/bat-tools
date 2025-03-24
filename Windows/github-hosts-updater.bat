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

:MAIN

SETLOCAL ENABLEDELAYEDEXPANSION

FOR /F "tokens=2 delims=:" %%l IN ('chcp') DO SET CHAR_CODE_PAGE=%%l

SET CHAR_CODE_PAGE=!CHAR_CODE_PAGE:~1!

IF !CHAR_CODE_PAGE! NEQ 65001 (
    CHCP 65001 2>&1 >NUL
)

@ECHO [!TIME!] Info: Creating a temporary 'hosts' file ...
SET TEMP_HOSTS=%TEMP%\hosts
ECHO.>"!TEMP_HOSTS!"
DEL /F /S /Q "!TEMP_HOSTS!" 2>&1 >NUL
IF NOT ERRORLEVEL 0 (
    @ECHO [!TIME!] Error: Could not create a temporary 'hosts' file ...
    GOTO END
)

@ECHO [!TIME!] Info: Writing 'hosts' contents into the temporary file ...
SET READING=1
FOR /F "delims=" %%l IN ('FINDSTR /N ".*" "%SystemRoot%\System32\drivers\etc\hosts"') DO (
    FOR /F "tokens=1,2* delims=: " %%a IN ("%%l") DO (
        IF "%%b"=="#" (
            IF !READING! EQU 1 (
                ECHO %%l | FINDSTR /R /I /C:"\<Start\>" >NUL
                IF !ERRORLEVEL! EQU 0 (
                    SET READING=0
                )
            )
        )
        IF !READING! EQU 1 (
            IF "%%c"=="" (
                ECHO.%%b>>"!TEMP_HOSTS!"
            ) ELSE (
                ECHO.%%b %%c>>"!TEMP_HOSTS!"
            )
        )
        IF "%%b"=="#" (
            IF !READING! EQU 0 (
                ECHO %%l | FINDSTR /R /I /C:"\<End\>" >NUL
                IF !ERRORLEVEL! EQU 0 (
                    SET READING=1
                )
            )
        )
    )
)

@ECHO [!TIME!] Info: Merging 'Github Hosts' contents into the temporary file ...
SET WRITING=0
FOR /F "delims=" %%l IN ('curl -s https://gitlab.com/ineo6/hosts/-/raw/master/next-hosts') DO (
    FOR /F "" %%a IN ("%%l") DO (
        IF "%%a"=="#" (
            IF !WRITING! EQU 1 (
                ECHO %%l | FINDSTR /R /I /C:"\<End\>" >NUL
                IF !ERRORLEVEL! EQU 0 (
                    SET WRITING=0
                    ECHO %%l>>"!TEMP_HOSTS!"
                )
            ) ELSE (
                ECHO %%l | FINDSTR /R /I /C:"\<Start\>" >NUL
                IF !ERRORLEVEL! EQU 0 (
                    SET WRITING=1
                    ECHO %%l>>"!TEMP_HOSTS!"
                )
            )
        ) ELSE (
            IF !WRITING! EQU 1 (
                ECHO %%l>>"!TEMP_HOSTS!"
            )
        )
    )
)

@ECHO [!TIME!] Info: Replacing the original 'hosts' file ...
COPY /Y "!TEMP_HOSTS!" "%SystemRoot%\System32\drivers\etc\hosts" 2>&1 >NUL
IF NOT ERRORLEVEL 0 (
    @ECHO [!TIME!] Error: Could not replace the original 'hosts' file ...
    GOTO END
)

@ECHO [!TIME!] Info: Removing the temporary 'hosts' file ...
DEL /F /S /Q "!TEMP_HOSTS!" 2>&1 >NUL
IF NOT ERRORLEVEL 0 (
    @ECHO [!TIME!] Error: Could not remove the temporary 'hosts' file ...
    GOTO END
)


@ECHO [!TIME!] Info: Flushing the DNS cache ...
ipconfig /flushdns
IF NOT ERRORLEVEL 0 (
    @ECHO [!TIME!] Error: Could not flush the DNS cache ...
    GOTO END
)

@ECHO [!TIME!] Info: Process completed.

PAUSE

IF !CHAR_CODE_PAGE! NEQ 65001 (
    CHCP !CHAR_CODE_PAGE! 2>&1 >NUL
)

SETLOCAL DISABLEDELAYEDEXPANSION

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::

:END
IF NOT ERRORLEVEL 0 (
    PAUSE
)
EXIT 0