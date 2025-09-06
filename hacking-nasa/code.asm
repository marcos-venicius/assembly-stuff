extern convert_to_integer

global _start

section .text

_print_message:
  mov rax, 0x01
  mov rdx, rsi ; len
  mov rsi, rdi ; message
  mov rdi, 0x01
  syscall
  ret

_exit:
  mov rax, 0x3c
  mov rdi, 0x00
  syscall

_start:
  NOP
  mov rdi, hello_world_msg
  mov rsi, hello_world_msg_len
  call _print_message

  ; reading from input
  mov rax, 0x00
  mov rdi, 0x00
  mov rsi, input_buffer
  mov rdx, buffer_size
  syscall

  ; converting to number

  mov rdi, input_buffer
  mov rsi, rax
  call convert_to_integer ; returns to rax

  mov rbx, rax
  ;movzx rbx, byte [input_buffer]
  ;sub rbx, '0'

_loop:
  lea rdi, [number_buffer + 5]

  mov byte [rdi], ' '
  dec rdi

  mov eax, ebx
  add al, '0'
  mov [rdi], al
  mov rsi, rdi
  mov rdx, 2
  call _print_message

  dec rbx
  mov rdi, loop_msg
  mov rsi, loop_msg_len
  call _print_message

  cmp rbx, 0
  jg _loop

  call _exit

section .data

hello_world_msg     db "I'm hacking NASA how many times: " ;, 0x00 ; null terminator is only needed if using C
hello_world_msg_len equ $ - hello_world_msg

buffer_size equ 4

loop_msg     db "Hacking it...", 0x0A ;, 0x00 ; null terminator is only needed if using C
loop_msg_len equ $ - loop_msg

section .bss

input_buffer resb buffer_size
number_buffer resb 10
