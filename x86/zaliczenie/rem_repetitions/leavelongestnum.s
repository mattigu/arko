section .text
global leavelongestnum

leavelongestnum:
    push    ebp
    mov     ebp, esp
    mov     edx, [ebp +8]; string start

;allocate local var
    sub     esp, 8
    push    ebx
    push    edi

    xor     ebx, ebx
    xor     eax, eax

    jmp     find_digit

reset_longest:
;if ebx bigger than eax
    cmp     ebx, eax
    ja      set_new_longest

;reset current longest counter
    xor     ebx, ebx
    jmp     find_digit

set_new_longest:
;store new longest
    mov     eax, ebx
;store it's starting address
    mov     edi, edx
    sub     edi, ebx
    sub     edi, 1
;reset current longest counter
    xor     ebx, ebx

;eax len of longest seq so far
;edx iterator over string
;ebx current seq lenght
;ecx current char value

find_digit:

    mov     cl, [edx]
    inc     edx
    test    cl, cl
    jz      end
    cmp     cl, '0'
    jb      reset_longest
    cmp     cl, '9'
    ja      reset_longest

    inc     ebx
    jmp     find_digit

end:
;popping local variables
    mov     ebx, eax
    add     ebx, edi
    mov     ecx, 0
    mov     [ebx], ecx

    mov     eax, edi

    pop     edi
    pop     ebx


    mov     esp, ebp
    pop     ebp
    ret