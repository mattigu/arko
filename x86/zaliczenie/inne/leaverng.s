section .text
global leaverng

leaverng:
    push    ebp
    mov     ebp, esp

;allocate local variables
    sub     esp, 4
    push    edi

;get variables to register
    mov     al,[ebp + 12] ;a
    mov     ah,[ebp + 16] ;b
    mov     ecx,[ebp + 8]; string
    mov     edi, ecx

find_wanted:
    mov     dl, [ecx]
    inc     ecx
    test    dl, dl
    jz      end

;compare to a
    cmp     dl, al
    jb      find_wanted
;compare to b
    cmp     dl, ah
    ja      find_wanted

write:
    mov     [edi],  dl
    inc     edi
    jmp     find_wanted

end:
;place null
    mov     eax, 0
    mov     [edi], eax

    mov     eax, [ebp + 8]
    pop     edi

    mov     esp, ebp
    pop     ebp
    ret
