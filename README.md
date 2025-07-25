# 🧮 Binary-Decimal-Hexadecimal Calculator (NASM x86)

A simple command-line calculator written in x86 Assembly using NASM (Linux).  
Supports number base conversions and 1-bit binary logic operations — low-level and powerful.

---

## 🚀 Features

✅ Decimal ➜ Binary + Hexadecimal  
✅ Binary ➜ Decimal + Hexadecimal  
✅ Hexadecimal ➜ Decimal + Binary  
✅ 1-bit Binary AND, OR, XOR, NOT  
✅ Input validation (binary: only accepts `0` or `1`)  
✅ 16-bit binary output format  
✅ Hex output padded to 4 digits  
✅ Clean menu-driven interface using syscall I/O

---

## 🛠 Tech Stack

- **Language:** Assembly (x86 NASM)
- **System:** Linux (32-bit syscall interface)
- **Build Tool:** `nasm`, `ld`
- **Environment:** Terminal-based, works best in Linux shell (e.g. Ubuntu)

---

## 🧑‍💻 How to Build

```bash
nasm -f elf32 calculator.asm -o calculator.o
ld -m elf_i386 calculator.o -o calculator
./calculator
