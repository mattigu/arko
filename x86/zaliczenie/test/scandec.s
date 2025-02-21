        section .text
        global  scandec
scandec:
        push    ebp
        mov     ebp, esp
        mov     ecx, [ebp + 8] ;adress of first argument
        xor     edx, edx ; 
findnum:
        mov     dl, [ecx] ; moving main argument into lsb of D
        inc     ecx ; increment by one?
        test    dl, dl ; and on itself(only sets flags)
        jz      fin ; jump if 0(null)
        cmp     dl, '0'
        jb      findnum
        cmp     dl, '9'
        ja      findnum
        ; 1st digit found
        xor     eax, eax ; 0 to eax
nextdigit:
        lea     eax, [eax + eax*4]
        lea     eax, [eax * 2 + edx - '0']
        mov     dl, [ecx] ; next element after the first one
        inc     ecx
        test    dl, dl
        jz      fin
        cmp     dl, '0'
        jb      fin
        cmp     dl, '9'
        jbe     nextdigit

fin:
        pop     ebp
        ret