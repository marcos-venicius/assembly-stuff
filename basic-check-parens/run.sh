#!/usr/bin/env bash

nasm -felf64 main.asm && ld main.o && ./a.out ; echo $?
