@echo off
tools\vasm -quiet -devpac -Fhunk -o src\eagle.o src\eagle.asm
tools\vlink -S -s -o eagle src\eagle.o
del src\eagle.o
