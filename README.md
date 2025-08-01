# win32_api_sockets
A win 32 api sockets simple http [reverse port forwarding proxy](https://www.cloudflare.com/en-gb/learning/cdn/glossary/reverse-proxy/) implementation in *86 assembler.

# Links
https://www.reddit.com/r/asm/comments/1d7e3j2/windows_x64_assembly_api_and_socket/ <br>
https://stackoverflow.com/questions/74887725/cant-send-data-to-socket-server-in-assembly-language-x86-64-on-linux <br>
https://stackoverflow.com/questions/58168489/assembly-socket-creation-crash <br>

# Prerequisites:
https://www.nasm.us <br>
https://www.godevtool.com <br>

# Error codes (check stderr):
https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499- <br>

## Common codes:
WSAECONNREFUSED

`10061 (0x274D)`

Check if backend is active:
`python -m http.server -d C:\your_root_dir_here\winapi_win_example\src\sample 8081`

# Usage
Proxy host: `localhost:8192` <br>
Back end: `localhost:8081`
