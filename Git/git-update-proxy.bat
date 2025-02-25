@echo off
for /f tokens^=2^ usebackq %%i in (`netsh winhttp show advproxy ^| findstr \"ProxyIsEnabled\"`) do @(if "%%i" equ "true," for /f tokens^=4^ delims^=^"^ usebackq %%i in (`netsh winhttp show advproxy ^| findstr \"Proxy\"`) do @(set sockaddr=%%i))
git config --global http.proxy http://%sockaddr%
git config --global https.proxy https://%sockaddr%
