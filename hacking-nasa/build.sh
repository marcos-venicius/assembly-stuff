#!/usr/bin/env bash

set -xe

gcc -c -o libs.o libs.c && nasm -felf64 code.asm && ld code.o libs.o -o out

