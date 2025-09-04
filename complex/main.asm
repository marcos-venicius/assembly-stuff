global _start

BUFFER_SIZE EQU 0x32 ; 50
STDIN_FD    EQU 0x00
STDOUT_FD   EQU 0x01
STDERR_FD   EQU 0x02
OP_WRITE    EQU 0x01
OP_READ     EQU 0x00

section .bss

buffer resb BUFFER_SIZE

section .data

ok          db  "BALANCED", 0x0A
ok_size     equ $ - ok

fail        db  "UNBALANCED", 0x0A
fail_size   equ $ - fail

section .text

_read_input:
  mov rax, OP_READ
  mov rdi, STDIN_FD
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

  cmp rbx, 0x00
  je _success

  xor rcx, rcx
_loop:
  cmp byte [rdi], '('
  je _handle_left_paren
  cmp byte [rdi], ')'
  je _handle_right_paren
  jmp _continue

_handle_left_paren:
  inc rcx
  push '('
  jmp _continue
_handle_right_paren:
  cmp rcx, 0x00
  je _error

  pop rsi

  cmp rsi, '('
  jne _error

  dec rcx
  jmp _continue

_continue:
  inc rdi
  dec rbx
  cmp rbx, 0x00
  jne _loop

  cmp rcx, 0x00
  jne _error

_success:
  push 0x00
  mov rax, OP_WRITE
  mov rdi, STDERR_FD
  mov rsi, ok
  mov rdx, ok_size
  syscall
  jmp _exit

_error:
  push 0x01
  mov rax, OP_WRITE
  mov rdi, STDERR_FD
  mov rsi, fail
  mov rdx, fail_size
  syscall

_exit:
  pop rcx
  mov rax, 0x3C
  mov rdi, rcx
  syscall

