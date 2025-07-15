section .bss
  err_code resb 12
  written resb 12
  wsa_data resb 128
  addr resb 16
  cl_addr resb 16
  req_buf resb 512
  
section .data 
  IPPROTO_TCP equ 6
  SOCK_STREAM equ 1
  VERSION equ 0x202
  MSG_WAITALL equ 0x0008
  time_delay equ 1000

section .data
  AF_INET equ 2
  port equ 8192
  backlog equ 10
  in_addr db "127.0.0.1", 0

section .text
  extern WSAStartup, socket
  extern htons, inet_addr
  extern bind, listen, Sleep
  extern accept, send, ExitProcess
  extern _proxy, resp_buf, recv, connect
  extern _forward

  global _main
  _main:
    lea eax, wsa_data
    push eax
    push VERSION
    call WSAStartup
    test eax, eax
    jnz _onerr

    push IPPROTO_TCP
    push SOCK_STREAM
    push AF_INET
    call socket
    mov ebx, eax
    cmp ebx, 0
    jl _onerr

    mov byte [addr], AF_INET
    push port
    call htons
    mov ecx, eax
    mov [addr + 2], ecx
    push in_addr
    call inet_addr
    mov dword [addr + 4], eax

    push 16
    push addr
    push ebx
    call bind
    test eax, eax
    jnz _onerr

    push backlog
    push ebx
    call listen
    test eax, eax
    jnz _onerr

    _acceptloop:
      push 0
      lea ecx, cl_addr
      push ecx
      push ebx
      call accept
      cmp eax, 0
      jl _onerr
      mov esi, eax

      push time_delay
      call Sleep

      push MSG_WAITALL
      push 512
      lea eax, req_buf
      push eax
      push esi
      call recv 
      mov edi, eax

      Jmp _forward

      _send:
        push 0
        push edi
        push resp_buf
        push esi
        call send

      jmp _acceptloop

    push 0
    call ExitProcess

  _onerr:
    extern WSAGetLastError
    extern GetStdHandle, WriteConsoleA

    call WSAGetLastError
    mov ebx, 10
    lea esi, err_code
    add esi, 12
    mov edi, esi
    mov byte [esi], 0

    _convert:
      dec esi
      xor edx, edx
      div ebx
      add dl, '0'
      mov byte [esi], dl 
      test eax,eax
      jnz _convert

    push -12
    call GetStdHandle
    mov ebx, eax

    push 0
    lea ecx, written
    push ecx
    sub edi, esi
    push eax
    push esi 
    push ebx
    call WriteConsoleA

    push 0
    call ExitProcess

