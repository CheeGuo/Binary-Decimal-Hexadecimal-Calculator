==========================================
Binary Decimal Hexadecimal Calculator (NASM)
==========================================

This is a simple command-line calculator written in x86 NASM Assembly (Linux) that allows users to convert between binary, decimal, and hexadecimal, as well as perform basic 1-bit binary operations like AND, OR, XOR, and NOT.

----------------------
📦 Features
----------------------
1. Decimal → Binary & Hexadecimal
2. Binary → Decimal & Hexadecimal
3. Hexadecimal → Decimal & Binary
4. Binary AND
5. Binary OR
6. Binary XOR
7. Binary NOT

----------------------
🛠 Requirements
----------------------
- Linux OS
- NASM assembler
- 32-bit linker (ld) and libraries

----------------------
🚀 How to Build & Run
----------------------

1. Assemble the file:
   nasm -f elf32 calculator.asm -o calculator.o

2. Link the object file:
   ld -m elf_i386 calculator.o -o calculator

3. Run it:
   ./calculator

----------------------
🖥 Example Usage
----------------------
When you run the program, a menu will appear. You can choose options like:

> 1. Decimal to binary and hexadecimal  
> 2. Binary to decimal and hexadecimal  
> 4. Binary (AND)

And it will ask you for input values accordingly.

----------------------
📌 Notes
----------------------
- Input validation is included for binary inputs (must be 0 or 1).
- Only supports 1-bit operations for logical choices (AND, OR, etc).
- Outputs are shown in 16-bit binary and 4-digit hexadecimal.

----------------------
👨‍💻 Author
----------------------
Created with passion by a CG Handsome Boy 😎  
As part of a Computer Architecture project.

Feel free to use, fork, or improve this repo.

----------------------
📂 Files
----------------------
- calculator.asm   — the main assembly source code
- README.txt       — this file
