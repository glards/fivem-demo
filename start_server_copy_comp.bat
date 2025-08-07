@echo off
REM set GRPC_TRACE=all
REM set GRPC_VERBOSITY=DEBUG
D:\tools\SysinternalsSuite\pskill.exe FXServer
xcopy "D:\Perso\glards-scripting-external\src\component\glards-scripting-external\out\build\x64-Release\bin\*.dll" "D:\Perso\fivem-demo\.server" /Y
D:/Perso/fivem-demo/.server/FXServer.exe +set serverProfile "default"
pause