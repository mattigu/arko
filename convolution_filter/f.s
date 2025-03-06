global f

section .data
    d_1         dq      1.0

    matrix1_corner  dq      0.0
    matrix1_edge    dq      -1.0
    matrix1_mid     dq      5.0
    matrix2_corner  dq      1.0
    matrix2_edge    dq      2.0
    matrix2_mid     dq      -4.0


section .text
;RDI pixel pointer
;RSI width
;RDX height

;RCX bpp (bytes)

;R8 save adress
;R9 padding
;x, y on stack


f:
    push rbp
    mov rbp, rsp

; push saved

    sub rsp, 32

    push r13
    push r14
    push r15
    push rbx

reset_registers: ; for now for safety

    xor rax, rax
    xor rbx, rbx
    xor r10, r10
    xor r10, r10
    xor r12, r12
    xor r13, r13
    xor r14, r15
    xor r15, r15


setup_counters:
;padding at rbp +16
;rdi current byte blurred pointer
;r8 write adress in the new bmp
;r9 padding

;r12 bpp(bytes)
    mov     r12, rcx

;r13 rows left
    mov     r13, rdx
    xor     rdx, rdx

;r14 bytes left in row
;rsi bytes in row
    mov     rax, r12
    mul     rsi
    mov     r14, rax
    mov     rsi, rax

    ;height(not changing)
    mov     r11, r13

;left to use are a,b,c,d

delete:
    xor     rax, rax
    xor     rbx, rbx
    xor     rcx, rcx
    xor     rdx, rdx


distance:


    mov     eax, r14d
    mov     ecx, r12d
    div     ecx

    sub     rax, [rbp + 16] ; delta x
    imul    rax, rax        ; (delta x)^2
    mov     rbx, rax

    mov     rax, r13

    sub     rax, [rbp + 24] ; delta y
    imul    rax, rax        ; (delta y)^2

    add     rax, rbx        ; (delta x)^2 + (delta y)^2


sqrt_root:
    cvtsi2sd    xmm0, rax
    sqrtsd      xmm0, xmm0 ;r

;r in xmm0

    xor     rax, rax
;choose width or height
    mov     edx, 0
    mov     eax, esi
    mov     ecx, r12d
    div     ecx

    ;eax width
    ;r11 height
    cmp     eax, r11d
    jb      calculate_w
    mov     eax, r11d

;min(width/height) in eax
calculate_w:

    shl     rax, 1 ;min(h, w)*2

    cvtsi2sd    xmm2, rax ;min(h, w)*2

    divsd   xmm0, xmm2 ;r/(min(h, w)*2)

    movsd   xmm4, [d_1]

    movsd   xmm1, xmm0

    ;choosing min(r/(min(h, w)/2), 1)
    ucomisd     xmm1, xmm4
    jb   setup_loading
    movsd       xmm1, xmm4

;xmm 6 sum of pixels

setup_loading:
    ;setup helping adresses
    mov     rax, r12; negative bpp
    neg     rax
    mov     rdx, rsi; negative bytes in row
    neg     rdx
    sub     rdx, r9 ; sub padding


middle: ;min(w) in xmm1
    xor     rbx, rbx
    movzx   rbx, byte[rdi]

    cvtsi2sd xmm6, rbx ;middle value

    movsd   xmm2, [matrix2_mid]

    mulsd   xmm2, xmm1
    addsd   xmm2, [matrix1_mid]

    mulsd   xmm6, xmm2

corners:
    xor     rcx, rcx

    lea     rbx, [rdi+r12]
    add     rbx, r9 ;add padding
    movzx   rbx, byte[rbx + rsi]; tr
    add     rcx, rbx

    lea     rbx, [rdi+rax]
    add     rbx, r9 ;add padding
    movzx   rbx, byte[rbx + rsi]; tl add pad
    add     rcx, rbx

    lea     rbx, [rdi+rax]
    movzx   rbx, byte[rbx + rdx]; bl
    add     rcx, rbx

    lea     rbx, [rdi+r12]
    movzx   rbx, byte[rbx + rdx]; br
    add     rcx, rbx


    cvtsi2sd xmm0, rcx ;corners sum

    movsd   xmm2, [matrix2_corner]

    mulsd   xmm2, xmm1 ;mask*w
    addsd   xmm2, [matrix1_corner]

    mulsd   xmm0, xmm2
    addsd   xmm6, xmm0


edges:
    xor     rcx, rcx

    movzx   rbx, byte[rdi+r12];l
    add     rcx, rbx

    movzx   rbx, byte[rdi+rax];r
    add     rcx, rbx

    movzx   rbx, byte[rdi+rsi];t add padd
    add     rcx, rbx

    movzx   rbx, byte[rdi+rdx];b
    add     rcx, rbx


    cvtsi2sd xmm0, rcx ;corners sum

    movsd   xmm2, [matrix2_edge]

    mulsd   xmm2, xmm1
    addsd   xmm2, [matrix1_edge] ;mask3 = mask1 + mask2 * w

    mulsd   xmm0, xmm2;
    addsd   xmm6, xmm0

    cvtsd2si        rcx, xmm6


    ;if rcx above

    cmp  rcx, 0
    jl  set_zero

    cmp  rcx, 255
    jbe  save_pixel
    mov  rcx, 255 ;set max
    jmp  save_pixel

set_zero:
    mov     rcx, 0

save_pixel:
    mov     [r8], cl
    inc     r8

row_check:
    dec     r14
    jnz     next_byte

row_ended:
    dec     r13
    jz  end ;if rows ended end program

    add     rdi, r9

    ;reset bytes in row left counter
    mov     r14, rsi

next_byte:

    inc  rdi; inc current blurred byte
    jmp  delete

end:

; pop saved in the future
    pop     rbx
    pop     r15
    pop     r14
    pop     r13

    mov     rsp, rbp
    pop     rbp

    ret