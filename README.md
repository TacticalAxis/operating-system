# Commands

## Creating development environment

```bash
docker build buildenv -t os-buildenv
```

## Running development environment

```bash
docker run --rm -it -v $(pwd):/root/env os-buildenv
```

```powershell
docker run --rm -it -v %cd%:/root/env os-buildenv
```

## Running the OS

```bash
qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso
```
