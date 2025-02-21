section .text
global f

f:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]

;push saved
    sub     esp, 4
    push    ebx


begin:
    mov cl, [eax]
    cmp cl, 0
    jz  end
    add cl, 1
    mov [eax], cl
    inc eax
    jmp begin

end:
;popsaved
    pop ebx

    mov esp, ebp
    pop ebp
    ret