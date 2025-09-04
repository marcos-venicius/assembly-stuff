#!/usr/bin/env python3
import sys

if len(sys.argv) != 2:
    print('please, provide the input to the program')
    exit(1)

data = sys.argv[1]

output = []

for i in range(0, len(data), 4):
    row = ['00'] * (4 - (len(data) - i))

    row += [hex(ord(x))[2:] for x in data[i:i+4][::-1]]

    output.append(''.join(row))

output = output[::-1]

print(' '.join(output))
