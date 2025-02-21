section .text
global f

f:
    push ebp
    mov ebp, esp
    mov edx, [ebp+8]

    xor ecx, ecx
; simple solution
; letter1:
;     mov al, [edx]
;     inc edx
;     test al, al
;     jz end
;     cmp al, 0x61
;     jb letter2

; uppercase:
;     sub al, 32
;     mov [edx-1], al


; letter2:
;     mov al, [edx]
;     inc edx
;     test al, al
;     jz end
;     cmp al, 0x60
;     ja letter3

; lowercase:
;     add al, 32
;     mov [edx-1], al

; letter3:
;     mov al, [edx]
;     inc edx
;     test al, al
;     jz end

;     cmp al, 0x60
;     ja to_lower1

; ; to upper
;     add al, 32
;     mov [edx-1], al
;     jmp letter4


; to_lower1:
;     sub al, 32
;     mov [edx-1], al

; letter4:
;     mov al, [edx]
;     inc edx
;     test al, al
;     jz end

;     cmp al, 0x60
;     ja to_lower2

; ; to upper
;     add al, 32
;     mov [edx-1], al
;     jmp letter1

; to_lower2:
;     sub al, 32
;     mov [edx-1], al
;     jmp letter1

begin:
    mov eax, [edx]
    test al, al
    jz end


    xor eax, 0x20200000 ; last 2 digits
    or eax,  0x00002000 ;second digit
    and eax, 0xffffffdf ; first digit
    mov [edx], eax

    add edx, 4
    jmp begin



end:
    mov eax, [ebp +8]

    mov esp, ebp
    pop ebp
    ret

;example from board
; abcdABCDaAaA


; B B B B


;