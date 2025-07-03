section .bss
  pr_addr resb 16
  resp_buf resb 512

section .data
  out_port equ 8081
  AF_INET equ 2
  IPPROTO_TCP equ 6
  SOCK_STREAM equ 1
  MSG_WAITALL equ 0x0008
  MSG_DONTROUTE equ 0x0004
  time_delay equ 2000 

section .text 
  extern htons, inet_addr
  extern _send, _onerr
  extern in_addr, connect, socket 
  extern Sleep, shutdown, closesocket
  extern req_buf, send, recv
  _proxy: 
    push ebx 

    push IPPROTO_TCP 
    push SOCK_STREAM
    push AF_INET
    call socket
    test eax, eax
    jz _onerr
    mov ebx, eax

    mov byte [pr_addr], AF_INET
    push out_port
    call htons
    mov ecx, eax
    mov [pr_addr + 2], ecx
    push in_addr
    call inet_addr
    test eax, eax
    jz _onerr
    mov dword [pr_addr + 4], eax

    push 16
    lea ecx, [pr_addr]
    push ecx
    push ebx
    call connect
    test eax, eax
    jnz _onerr

    push MSG_DONTROUTE
    push edi
    lea eax, req_buf
    push eax
    push ebx
    call send
    cmp eax, edi
    jl _onerr

    push time_delay
    call Sleep

    push 1
    push ebx
    call shutdown
    test eax, eax
    jnz _onerr

    push time_delay
    call Sleep

    push MSG_WAITALL
    push 512
    lea eax, [resp_buf]
    push eax
    push ebx
    call recv
    mov ecx, eax

    push time_delay
    call Sleep

    push 2
    push ebx
    call shutdown
    test eax, eax
    jnz _onerr

    push ebx
    call closesocket
    test eax, eax
    jnz _onerr

    pop ebx
    jmp _send
