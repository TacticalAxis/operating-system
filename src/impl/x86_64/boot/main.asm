global start

section .text
bits 32
start:
    ; store the address of the top of the stack into the esp register, since there are currently no frames on the stack
    mov esp, stack_top
    ; call the function to check we've been loaded by multiboot
    call check_multiboot
    ; check cpu features using cpuid
    call check_cpuid
    ; use cpu features to check if we can use long mode
    call check_long_mode
    ; setup page tables
    call setup_page_tables
    ; enable paging
    call enable_paging

    ; print "OK"
    ; mov dword [0x8000] 0x2f412f482f542f412f4e
    mov dword [0xb8000], 0x2f4b2f4f
    hlt

check_multiboot:
    ; compliant bootloaders will pass the multiboot magic number in eax (eax is a general purpose register)
    cmp eax, 0x36d76289
    ; jump to the no_multiboot label if the magic number is not present (jump not equal)
    jne .no_multiboot
    ; return if the magic number is present
    ret
.no_multiboot:
    ; store error code into the al register (the al register is the lowest 8 bits of the eax register)
    mov al, "M"
    ; jump to instructions that will display an error message
    jmp error

check_cpuid:
    ; to do this, we need to flip the 21st bit of the eflags register (the id bit), we start by pushing the flag register onto the stack
    pushfd
    ; next we need to pop the flags off the stack into the eax register
    pop eax
    ; then let's copy them to the ecx register (mov LOCATION, VALUE), so we can later on compare if the bit is successfully flipped
    mov ecx, eax
    ; perform an xor to flip the 21st bit of the eflags register (1 << 21 means (eli5) 1 shifted 21 bits to the left (we have moved 1 << 21 into eax)
    xor eax, 1 << 21
    ; push the modified flags that is in eax back onto the stack
    push eax;
    ; pop the modified flags off the stack back into the flags register
    popfd
    ; copy the flags back onto the stack
    pushfd
    ; pop the flags off the stack into the eax register
    pop eax
    ; push the original flags that were in ecx back onto the stack
    push ecx
    ; pop whatever is at the top of the stack into the flags register
    popfd
    ; now we compare eax (which contains the modified flags) with ecx (which contains the original flags)
    cmp eax, ecx
    ; if they are equal, we cannot use cpuid
    je .no_cpuid
    ; return
    ret
.no_cpuid:
    ; store error code into the al register
    mov al, "C"
    ; jump to instructions that will display an error message
    jmp error

check_long_mode:
    ; first we need to check if cpuid supports extended processor information
    ; move 0x80000000 into eax
    mov eax, 0x80000000
    ; cpuid then takes in eax as an implicit argument. If it sees the 0x80000000 magic number, it will store a number back into eax which is higher than 0x80000000 if it supports extended processor information
    cpuid
    ; compare the value in eax with 0x80000000 + 1 (if it supports extended processor information, it will return a value higher than 0x80000000)
    cmp eax, 0x80000001
    ; we will now use jb to jump below if the value in eax is less than 0x80000001 (jump if below, no long mode)
    jb .no_long_mode

    ; otherwise we can use extended processor information to check if long mode is supported
    ; move 0x80000001 into eax to now start checking for long mode support
    mov eax, 0x80000001
    ; this time cpuid will store information into the edx register
    cpuid
    ; the ln bit is the 29th bit of the edx register
    ; we will use the test instruction to check if the ln bit is set
    test edx, 1 << 29
    ; jz means jump if zero, so if the ln bit is not set, we will jump to the no_long_mode label
    jz .no_long_mode
    ; return if long mode is supported
    ret
.no_long_mode:
    ; store error code into the al register
    mov al, "L"
    ; jump to instructions that will display an error message
    jmp error

setup_page_tables:
    ; TODO: implement PAGE TABLES

error:
    ; print "ERR: X" where X is the error code
    mov dword [0xb8000], 0x4f524f45 ; OROE
    mov dword [0xb8004], 0x4f3a4f52 ; O:OR
    mov dword [0xb8008], 0x4f204f20 ; O O 
    ; move the byte in the al register to the memory address 0xb800a
    mov byte [0xb800a], al
    ; halt the cpu
    hlt







; bss section contains static variables
; this memory will be reserved when the bootloader loads the kernel
; the cpu uses the esp register to determine the address of the current stack frame (a.k.a the stack pointer)
section .bss
align 4096
page_table_l4:
    resb 4096
page_table_l3:
    resb 4096
page_table_l2:
    resb 4096
stack_bottom:
    ; reserve 16 KB for stack
    resb 4096 * 4
stack_top: