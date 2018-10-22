; Copyright Ty Miller 2011-2018 - The Shellcode Lab
; Semi-colons start comments in ASM - comment everything you can because you will forget what the ASM code doe
s
; Simplest Linux shellcode ever - execute the "exit" syscall to terminate the program

[SECTION .text]                 ; The text segment is also known as the code segment
BITS 32                         ; Sets the architecture to be 32-bit

    int3                        ; breakpoint for debugger

                                ; Linux places the syscall number we want to execute into EAX.
                                ; The syscall number for "sys_exit" can be found in:
                                ;     For 32-bit: /usr/include/i386-linux-gnu/asm/unistd_32.h
                                ;     For 64-bit: /usr/include/i386-linux-gnu/asm/unistd_64.h
                                ;     Note: You also can find the syscall list here: "man 2 syscalls"
                                ;
                                ; The syntax says that for IA-32 the system call number goes in EAX, and the
                                ; parameters goes in EBX, ECX, EDX, ESI, EDI and EBP.
                                ; If the syscall has more than 6 parameters, they should be pushed into the st
ack,
                                ; and a pointer to this structure should be placed in EBX
                                ; More Info: man 2 syscall
                                ;
                                ; To check the parameters for exit(), do: man 2 exit
                                ;
                                ; For our code exit(0):
                                ;     EAX <= 1 (__NR_exit)
                                ;     EBX <= 0
                                ;
                                ; This shows we want to put value 1 into EAX
                                ; move value 1 into the EAX register.
                                ; THIS TIME WITHOUT NULLS IN THE SHELLCODE
                                ; mov eax, 1
    xor eax, eax                ; zero out EAX register by XOR'ing it with itself (eg, 10011101 XOR 10011101 =
 00000000)
                                ; This command contains no NULL characters
    mov al, 1                   ; AL = lowest 8-bits of EAX ... we place 1 into AL to make EAX now contain 1
                                ; This command contains no NULL characters

                                ; The syscall reference above shows we need to put "int error_code" into EBX
                                ; We will arbitrarily put the error code of 0 into EBX
                                ; move 0 into EBX
                                ; THIS TIME WITHOUT NULLS IN THE SHELLCODE
    ; mov ebx, 0
    xor ebx, ebx                ; zero out EBX register via XOR

    int 0x80                    ; To execute the syscall we always use "int 0x80"
