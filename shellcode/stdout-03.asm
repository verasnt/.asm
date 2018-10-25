; Copyright Ty Miller 2011-2018 - The Shellcode Lab
; Develop shellcode to write to stdout and then exit using the "write" syscall

[SECTION .text]
BITS 32
    int3                        ; breakpoint

                                ; Place syscall number for "write" into EAX
                                ; The syscall number for "sys_write" can be found in:
                                ;     For 32-bit: /usr/include/i386-linux-gnu/asm/unistd_32.h
                                ;     For 64-bit: /usr/include/i386-linux-gnu/asm/unistd_64.h
                                ;     Note: You also can find the syscall list here: "man 2 syscalls"
                                ;
                                ; To check the parameters for write(), do: man 2 write
                                ;
                                ; For our code write(1, &'theshellcodelab\n', 16):
                                ;     EAX <= 4 (__NR_write)
                                ;     EBX <= 1 (STDOUT FD)
                                ;     ECX <= &string (The string address that we want to write)
                                ;     EDX <= 16 (string lenght)
                                ;
                                ; This shows we want to zero out EAX, then move the value 4 into EAX
    xor eax, eax                ; zero out EAX
    mov al, 4                   ; write (syscall 4)

                                ; write syscall requires "unsigned int fd" in EBX (fd is the file descriptor)
    xor ebx, ebx                ; zero out EBX
    mov bl, 1                   ; stdout file descriptor (fd) is 1

                                ; write syscall requires "const char __user" in ECX (__user is the string we want to write)
    jmp short get_string        ; Our string is located at the bottom of the code, so jump down to it
get_string_return:              ; Define a label so we know where to return to our code
    pop ecx                     ; pop the address of the string from the stack (address was pushed onto stack from call instruction below)

                                ; write syscall requires "*buf size_t count" in EDX (buf is the number of characters in the string we want to write)
    xor edx, edx                ; zero out EDX
    mov dl, 16                  ; our string is 16 characters long, so move it into EDX (moving to DL is smaller)

    int 0x80                    ; execute "sys_write" syscall


                                ; Exit code from previous lab
    xor eax, eax                ; zero out eax
    mov al, 1                   ; syscall "sys_exit" is 1
    xor ebx, ebx                ; zero out ebx
    int 0x80                    ; execute sys_exit syscall


get_string:                     ; This is a label. Used to mark positions in our code so we can jump/call to the location.
    call get_string_return      ; The call instruction is used to call a function. In this case, we call our get_string_return label.
                                ; call pushes the memory address of the next instruction onto the stack. In this case, the address of our string.
                                ; Usually, when a function returns the "ret" instruction pops the memory address off the stack and jumps to it.
                                ; Shellcode uses the call instruction to push the memory location of a string onto the stack.
                                ; The memory location of the string is then popped into our target register, as shown above.
    db 'theshellcodelab',0xa    ; Our string. db writes raw bytes into the ASM code

