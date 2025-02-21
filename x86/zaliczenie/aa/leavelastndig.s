section .text
global leavelastndig

leavelastndig:
    push    ebp
    mov     ebp, esp
    mov     ecx, [ebp +8] ;string
    mov     edx, [ebp + 12] ;n

;local variables
    sub     esp, 4
    push    ebx
    mov     ebx, ecx

findnum:
    mov     al, [ecx] ; moving char argument into lsb of eax
    inc     ecx;
    test    al, al ;
    jz      end ; jump if 0(null)
    cmp     al, '0'
    jb      findnum
    cmp     al, '9'
    ja      findnum

save_num:
    mov     [ebx], al
    inc     ebx
    jmp     findnum

;ebx where null should be
;ecx 1 after original null
;edx n
;eax unused at this point

end:
;null so string ends
    xor     al, al
    mov     [ebx], al

;address where the last n digits start
    mov     eax, ebx
    sub     eax, edx

; popping local variables
    pop     ebx

    mov     esp, ebp
    pop     ebp
    ret
    