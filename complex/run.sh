#!/usr/bin/env bash

nasm -felf64 main.asm && ld main.o -o isbalanced && ./isbalanced; echo $?
