section .data
    eq db "they are equal", 0xa

section .bss 
    I_SIZE equ 0x1000
    O_SIZE equ I_SIZE+0x40
    _o: RESB O_SIZE-I_SIZE
    _i: RESB I_SIZE+0xc
    _i0: RESD 0x1
    _o0: RESD 0x1

section .text
    global _start

scan:
    mov edx, [_i0]
    movzx eax, byte[_i+edx]
    .1: inc edx
    cmp byte[_i+edx], '0'
    jl .2
    lea ecx, [eax+eax*4]
    movzx eax, byte[_i+edx]
    lea eax, [eax+ecx*2-480]
    jmp .1
    .2: sub eax, 0x30
    inc edx
    mov [_i0], edx
    ret

print:
    xor ecx, ecx
    mov ebx, 0xa
    .1: xor edx, edx
    div ebx
    add dl, 0x30
    mov [_o+O_SIZE+ecx], dl
    inc ecx
    cmp eax, 0x0
    jnz .1
    mov ebx, [_o0]
    .2: mov al, [_o+O_SIZE+ecx-1]
    mov [_o+ebx], al
    inc ebx
    dec ecx
    jnz .2
    mov byte[_o+ebx], 0xa
    inc ebx
    mov [_o0], ebx
    ret

_start:
    mov edx, I_SIZE
    mov ecx, _i
    xor ebx, ebx
    mov eax, 0x3
    int 0x80

    call scan
    mov ebx, eax
    call scan
    cmp eax, ebx
    jl .el
    je .eq
    call print
    jmp .end
    .el:
    mov eax, ebx
    call print
    jmp .end
    .eq:
    mov edx, 15
    mov ecx, eq
    jmp .e1
    .end:
    mov edx, [_o0]
    mov ecx, _o
    .e1:
    xor ebx, ebx
    inc ebx
    mov eax, 0x4
    int 0x80

    xor ebx, ebx
    xor eax, eax
    inc eax
    int 0x80
