global _start

BUFFER_SIZE EQU 50

section .bss

buffer resb BUFFER_SIZE

section .text

_read_input:
  mov rax, 0x00
  mov rdi, 0x00
  mov rsi, buffer
  mov rdx, BUFFER_SIZE
  syscall
  ret

_start:
  call _read_input
  mov rbx, rax
  lea rdi, [buffer]

  cmp byte [rdi + rbx - 1], 0x0A  ; check if there is a new line at the end
  jne _no_newline
  dec rbx                         ; ignore newline
  _no_newline:
  push rbx

  xor rcx, rcx
_loop:
  cmp byte [rdi], '('   ; case '('
  je _add_left          ; increment counter
  cmp byte [rdi], ')'   ; case ')'
  je _add_right         ; decrement counter
  jmp _unexpected       ; default case
_add_left:
  inc rcx
  jmp _continue         ; do not add right after adding left
_add_right:
  dec rcx
  jmp _continue

_unexpected:
  push 5
  mov rax, 0x01
  mov rdi, 0x01
  mov rsi, unexpected
  mov rdx, unexpected_size
  syscall
  jmp _exit

_continue:
  inc rdi
  dec rbx
  cmp rbx, 0x00
  jne _loop

  push rcx

  cmp rcx, 0x00
  jne _error

_success:
  mov rax, 0x01
  mov rdi, 0x01
  mov rsi, ok
  mov rdx, ok_size
  syscall
  jmp _exit

_error:
  mov rax, 0x01
  mov rdi, 0x01
  mov rsi, fail
  mov rdx, fail_size
  syscall

_exit:
  ; exit
  pop rcx
  mov rax, 0x3C
  mov rdi, rcx
  syscall

section .data

ok          db  "BALANCED", 0x0A
ok_size     equ $ - ok

fail        db  "UNBALANCED", 0x0A
fail_size   equ $ - fail

unexpected        db  "unexpected char", 0x0A
unexpected_size   equ $ - unexpected
