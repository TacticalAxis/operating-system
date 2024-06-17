global start

section .text
bits 32
start:
    ; print "OK"
    ; mov dword [0x8000] 0x2f412f482f542f412f4e
    mov dword [0xb8000], 0x2f4b2f4f
    hlt
