section .text 
  extern _proxy, req_buf
  _forward:
      push esi
      mov esi, [req_buf]

      _findhost:
        cmp byte [esi], 'H'   
        jne _nextchar
        cmp byte [esi + 1], 'o'    
        jne _nextchar      
        cmp byte [esi + 2], 's' 
        jne _nextchar
        cmp byte [esi + 3], 't'    
        jne _nextchar    
        cmp byte [esi + 4], ':'        
        je _foundhost      

      _nextchar:
        inc esi
        jmp _findhost        

      _foundhost: 
        mov byte [esi + 16], '8'
        mov byte [esi + 17], '0'
        mov byte [esi + 18], '8'
        mov byte [esi + 19], '1'

        pop esi
        jmp _proxy
