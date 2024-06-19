# Operating System

[![Build Operating System](https://github.com/TacticalAxis/operating-system/actions/workflows/build.yml/badge.svg)](https://github.com/TacticalAxis/operating-system/actions/workflows/build.yml)

## Creating development environment

```bash
docker build buildenv -t os-buildenv
```

## Running development environment

```bash
docker run --rm -it -v $(pwd):/root/env os-buildenv
```

## Building the OS in the development environment

```bash
make build-x86_64
```

## Running the OS

```bash
qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso
```

## General Notes

- eax, ebx, ecx, edx are general purpose registers
- esp is the stack pointer
- ebp is the base pointer
- esi, edi are source and destination index registers
- eip is the instruction pointer

- ax, ah, al are 16-bit, 8-bit registers
- ax is the lower 16-bits of eax
- ah is the higher 8-bits of ax
- al is the lower 8-bits of ax

- replace e with r for 64-bit registers
- rax, rbx, rcx, rdx are general purpose registers
- rsp is the stack pointer
- rbp is the base pointer
- rsi, rdi are source and destination index registers
- rip is the instruction pointer
