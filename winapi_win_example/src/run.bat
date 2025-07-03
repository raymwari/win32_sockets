@echo off
if exist main.exe (del main.exe main.obj)
nasm -f win32 main.asm
nasm -f win32 proxy.asm
nasm -f win32 forward.asm
if exist main.obj (golink /console /entry _main main.obj proxy.obj forward.obj kernel32.dll ws2_32.dll user32.dll)
if exist main.obj (del main.obj proxy.obj forward.obj)
if exist main.exe (main.exe)
