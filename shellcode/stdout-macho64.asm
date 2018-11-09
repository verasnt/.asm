; Mac OS-X 64-bit shellcode to write to stdout

[SECTION .text]
BITS 64

    int 3

                                ; Write a string to stdout

                                ; Mac OS X - ABI INFO: https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html#//apple_ref/doc/uid/TP40002521
                                ; Mac OS X - ABI INFO: https://opensource.apple.com/source/xnu/<XNU-VERSION>/osfmk/mach/i386/syscall_sw.h (Syscall Classes)
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_write          4
                                ; SYSCALL INFO: man 2 write
                                ; SYSCALL INFO:         ssize_t write(int fildes, const void *buf, size_t nbyte);
                                ; SYSCALL INFO: syscall num = rax = 0x02000004 (syscall class 2, syscall number 0x04)
                                ; SYSCALL INFO: parameter 1 = rdi = 1 (stdout file descriptor is 1)
                                ; SYSCALL INFO: parameter 2 = rsi = pointer to our string we want to write
                                ; SYSCALL INFO: parameter 3 = rdx = 9 (size of our string)

    xor rax, rax                ; zero rax (xor = 3 bytes)
    push rax                    ; push zero onto stack, so we can pop later to zero registers since push/pop is 2 bytes
    push rax                    ; push zero onto stack, so we can pop later to zero registers since push/pop is 2 bytes
    mov ax, 0x0402              ; get syscall class 2 and the syscall number 4 for write into ax
    ror eax, 8                  ; rotate the syscall numbers around into position
    pop rdi                     ; pop zero from stack (from above to zero rdi)
    pop rdx                     ; pop zero from stack (from above to zero rdx)
    xor r9, r9                  ; zero out r9. it will store our LF char, keeping the stack aligned.
    mov r9b, 0x0a               ; add LF char
    push r9                     ; pushing LF over the stack
    mov dil, 1                  ; move 1 into rdi for our stdout file descriptor
    mov rsi, "Hi World"         ; load the string directly into a register - cheated and removed the new line character
    push rsi                    ; push the string onto the stack so we can reference it
    mov rsi, rsp                ; copy pointer to our string on stack into rsi
    mov dl, 9                   ; move 9 into rdx for the size to write
    syscall                     ; Invoke the kernel

                                ; Exit the process
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_exit           1
                                ; SYSCALL INFO: int      exit(int code);
                                ; SYSCALL INFO: syscall num = rax = 0x01
                                ; SYSCALL INFO: parameter 1 = rdi = 0

    xor rax, rax                ; zero out rax (3 bytes)
    push rax                    ; push 0x0 on stack to zero rdi (1 byte)
    pop rdi                     ; zero out rdi (1 byte)
    mov al, 2                   ; get syscall call 2 into al
    shl rax, 24                 ; shift syscall class into position
    inc al                      ; get syscall number into al (exit = 1)
    syscall                     ; Invoke the kernel

