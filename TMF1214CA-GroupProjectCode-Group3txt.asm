
section .data
    menu db 10,'Binary Decimal Hexadecimal Calculator', 10,'Please choose the calculator that you need to use', 10, '1. Decimal to binary and hexadecimal', 10, '2. Binary to decimal and hexadecimal', 10, '3. Hexadecimal to decimal and binary',10,'4.Binary(AND)',10,'5.Binary(OR)',10,'6.Binary(XOR)',10,'7.Binary(NOT)',10,'Your Choice:',0
    
    msg1 db 'Enter a decimal number: ', 0
    msg2 db 'Enter a binary number: ', 0
    msg3 db 'Enter a hexadecimal number: ', 0
    output_msg db '16-bit binary: ', 0
    hex_msg db 'Hexadecimal: ', 0
    dec_msg db 'Decimal: ', 0
    newline db 10, 0
    hex_digits db '0123456789ABCDEF'
    your_choice db 'Your Choice:', 0
    Bresult db 'The result is ', 0  
    LBresult equ $ - Bresult
    Binary1 db 'First Binary Number(1/0):', 0
    LBinary1 equ $ - Binary1
    Binary2 db 'Second Binary Number(1/0):', 0
    LBinary2 equ $ - Binary2
    display12 db '-------' ,0xA 
    Lmenu equ $ - menu 

section .bss
    ;for menu
    option resb 16
    num resb 6
    ;option 1
    binary resb 16
    hexadecimal resb 4
    decimal resd 1
    ;option 2
    binary2 resb 16
    hexadecimal2 resb 4
    decimal2 resd 1
    ;option 3
    binary3 resb 16
    hexadecimal3 resb 4
    decimal3 resd 1
    ;option 4 
    binary4 resb 2
    binary5 resb 2
    result resb 2
    choice resb 2 
    buffer1 resb 1 ; Reserve 1 byte for buffer
    hold resb 2
    
section .text
    global _start
_start:
mov byte [binary4] , 0
mov byte [binary5] , 0
mov byte [option] , 0 
    ; Calculate the length of the menu
    mov ecx, menu
    mov edx, 0
menu_length:
    cmp byte [ecx + edx], 0
    je end_menu_length
    inc edx
    jmp menu_length
end_menu_length:
    ; Print the menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    int 0x80

    ; Read the user's choice
read_option:
    mov eax, 3
    mov ebx, 0
    mov ecx, option
    mov edx, 1
    int 0x80
    cmp byte [option], 10 ; newline character
     je read_option
     
    cmp byte[option], '1'
    jb _start 
    
    cmp byte[option] , '7'
    ja _start
    
    ; Decide based on user's choice
    movzx eax, byte [option]
    sub eax, '1'
    jmp [eax*4 + choice_dispatch]
choice_dispatch:
    dd choice_1, choice_2, choice_3, _binary, _binary, _binary, _binary

choice_1:   ; Convert decimal to binary and hexadecimal
    call decimal_to_bin_hex
    
    ; Print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    jmp _start

choice_2:   ; Convert binary to decimal and hexadecimal
    call binary_to_dec_hex
    
    ; Print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    jmp _start

choice_3:  ; Convert hexadecimal to decimal and binary
   call hex_to_dec_bin

    ; Print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp _start


;for choice 1
decimal_to_bin_hex:
    ; Print the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 24
    int 0x80

    ; Read the user's input
read_input:
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 5
    int 0x80
    cmp byte [num], 10 ; newline character
    je read_input
    
        ; Convert the ASCII string to an integer
    xor eax, eax
    xor ebx, ebx
convert_to_int:
    movzx ecx, byte [num + ebx]
    cmp ecx, '0'
    jb end_convert_to_int
    cmp ecx, '9'
    ja end_convert_to_int
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    inc ebx
    jmp convert_to_int
end_convert_to_int:

    ; Convert the number to binary
    mov ecx, 16
    mov ebx, eax
convert_to_binary:
    xor edx, edx
    mov ecx, 16
    mov ebx, eax
convert_decimal_to_binary:
    xor edx, edx
    mov edi, 2
    div edi
    add dl, '0'
    dec ecx
    mov [binary + ecx], dl
    test eax, eax
    jnz convert_decimal_to_binary

; If we haven't output 16 bits yet, pad with zeros
pad2:
    dec ecx
    cmp ecx, -1
    jz convert_to_hex
    mov byte [binary + ecx], '0'
    jmp pad2

convert_to_hex:
    ; Convert the number to hexadecimal
    mov ecx, 4
    mov eax, ebx
convert_to_hex_loop:
    xor edx, edx
    mov edi, 16
    div edi
    movzx ebx, dl
    mov dl, byte [hex_digits + ebx]
    dec ecx
    mov [hexadecimal + ecx], dl
    test eax, eax
    jnz convert_to_hex_loop

print_binary:
    ; Print the "Binary: " message
    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, 15
    int 0x80

    ; Print the binary number
    mov eax, 4
    mov ebx, 1
    mov ecx, binary
    mov edx, 16
    int 0x80

    ; Print a new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

print_hexadecimal:
    ; Print the "Hexadecimal: " message
    mov eax, 4
    mov ebx, 1
    mov ecx, hex_msg
    mov edx, 13
    int 0x80

    ; Print the hexadecimal number
    mov eax, 4
    mov ebx, 1
    mov ecx, hexadecimal
    mov edx, 4
    int 0x80

    ret


;for choice 2
binary_to_dec_hex:
    ; Print the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 23
    int 0x80

    ; Read the user's input
read_binary:
    mov eax, 3
    mov ebx, 0
    mov ecx, binary2
    mov edx, 17
    int 0x80
    cmp byte [binary2], 10 ; newline character
    je read_binary

    ; Convert binary to decimal
    xor eax, eax
    xor ebx, ebx
convert_binary_to_int:
    movzx ecx, byte [binary2 + ebx]
    cmp ecx, '0'
    jb end_convert_binary_to_int
    cmp ecx, '1'
    ja end_convert_binary_to_int
    sub ecx, '0'
    shl eax, 1
    add eax, ecx
    inc ebx
    cmp ebx, 16
    jb convert_binary_to_int
end_convert_binary_to_int:

    ; Store the number in decimal
    mov [decimal2], eax

    ; Print the "Decimal: " message
    mov eax, 4
    mov ebx, 1
    mov ecx, dec_msg
    mov edx, 9
    int 0x80

    ; Print the decimal number
    mov eax, [decimal2]
    call print_decimal

    ; Print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    jmp _start

print_decimal:
    ; Prepare the pointer to the end of buffer
    lea ecx, [num + 4]

    ; Store the number in a buffer
    xor ebx, ebx
print_decimal_loop:
    xor edx, edx
    mov edi, 10
    div edi
    add dl, '0'
    dec ecx
    mov [ecx], dl
    inc ebx
    test eax, eax
    jnz print_decimal_loop

    ; Calculate the length
    lea edx, [num + 4]
    sub edx, ecx

    ; Print the decimal number
    mov eax, 4
    mov ebx, 1
    int 0x80
    
        ; Convert decimal to hexadecimal
    mov eax, [decimal2]
    mov ecx, 4
    
convert_decimal_to_hex:
    xor edx, edx
    mov edi, 16
    div edi
    movzx ebx, dl
    mov dl, byte [hex_digits + ebx]
    dec ecx
    mov [hexadecimal2 + ecx], dl
    test eax, eax
    jnz convert_decimal_to_hex
    
    ; Print a new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
print_hexadecimal2:
    ; Print the "Hexadecimal: " message
    mov eax, 4
    mov ebx, 1
    mov ecx, hex_msg
    mov edx, 13
    int 0x80

    ; Print the hexadecimal number
    mov eax, 4
    mov ebx, 1
    mov ecx, hexadecimal2
    mov edx, 4
    int 0x80

    ret
    
;for choice 3    
hex_to_dec_bin:
    ; Print the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 28
    int 0x80

    ; Read the user's input
read_hexadecimal:
    mov eax, 3
    mov ebx, 0
    mov ecx, hexadecimal3
    mov edx, 5
    int 0x80
    cmp byte [hexadecimal3], 10 ; newline character
    je read_hexadecimal

; Convert hexadecimal to decimal
    xor eax, eax
    xor ebx, ebx
convert_hexadecimal_to_int:
    movzx ecx, byte [hexadecimal3 + ebx]
    cmp ecx, '0'
    jb end_convert_hexadecimal_to_int
    cmp ecx, 'F'
    ja end_convert_hexadecimal_to_int
    cmp ecx, '9'
    jbe skip_alpha
    sub ecx, 7
skip_alpha:
    sub ecx, '0'
    shl eax, 4
    add eax, ecx
    inc ebx
    cmp ebx, 4
    jb convert_hexadecimal_to_int
end_convert_hexadecimal_to_int:

    ; Store the number in decimal
    mov [decimal3], eax

; Print the "Decimal: " message
    mov eax, 4
    mov ebx, 1
    mov ecx, dec_msg
    mov edx, 9
    int 0x80

    ; Print the decimal number
    mov eax, [decimal3]
print_decimal2:
    ; Prepare the pointer to the end of buffer
    lea ecx, [num + 4]

    ; Store the number in a buffer
    xor ebx, ebx
print_decimal_loop2:
    xor edx, edx
    mov edi, 10
    div edi
    add dl, '0'
    dec ecx
    mov [ecx], dl
    inc ebx
    test eax, eax
    jnz print_decimal_loop2

    ; Calculate the length
    lea edx, [num + 4]
    sub edx, ecx

    ; Print the decimal number
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    ; Print new line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

   ; Convert the number to binary
    mov eax, [decimal3] ; load decimal value into eax
    
    convert_to_binary2:
    xor edx, edx
    mov ecx, 16
    mov ebx, eax
    convert_decimal_to_binary2:
    xor edx, edx
    mov edi, 2
    div edi
    add dl, '0'
    dec ecx
    mov [binary3 + ecx], dl
    test eax, eax
    jnz convert_decimal_to_binary2
    
    ; If we haven't output 16 bits yet, pad with zeros
    pad3:
    dec ecx
    cmp ecx, -1
    jle done_padding ; jump to done_padding when ecx is less or equal to -1
    
    mov byte [binary3 + ecx], '0'
    jmp pad3
    
    done_padding:
    
    ; Print binary
    mov eax, 4
    mov ebx, 1
    mov ecx, output_msg
    mov edx, 15
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, binary3
    mov edx, 16
    int 0x80
    
    ret
    
_binary:
   flush_stdin:
    mov eax, 3          ; sys_read syscall number (3)
    mov ebx, 0          ; File descriptor 0 (stdin)
    lea ecx, [buffer1]   ; Address of buffer
    mov edx, 1          ; Number of bytes to read
    int 0x80            ; Make the syscall
    cmp eax, 0          ; Check if EOF (eax == 0)
    je first_input       ; If EOF, end flushing
    cmp byte [buffer1], 10 ; Check if newline character (ASCII 10)
    jne flush_stdin     ; If not newline, continue reading
    
first_input:
    ; output ------
    mov byte[binary4] , 0 
    mov eax , 4 
    mov ebx , 1 
    mov ecx , display12  ; output a line to seperate the section 
    mov edx , 8
    int 0x80 
    ; output : first binary number 
    mov eax, 4
    mov ebx, 1
    mov ecx, Binary1 ; display to guide user to enter  the binary 
    mov edx, 25 ; only 25 byte 
    int 0x80
    ; Input binary 1
    mov eax , 3
    mov ebx , 0 ; stdin 
    mov ecx , binary4 ;input for first binary number 
    mov edx , 2  
    int 0x80
     
    sub byte[binary4] , '0' ; change binary4 to numeric 
    ; check invalid , only enter 1 or 0 
    cmp byte[binary4], 0 ; check invalid , below zero
    jb first_input
 cmp byte[binary4] , 1 ;
    ja first_input 
    
    cmp byte [option], '7' ; if option is 4 , jump to NOT
    je not1
   
second_input:
    mov byte[binary5] , 0 ; clear second binary variable to zero
    ; Please enter the second number
    mov eax, 4
    mov ebx, 1
    mov ecx, Binary2 ; display to guide user to enter second binary 
    mov edx, 26  
    int 0x80
 
    ; Input binary 2
    mov eax, 3
    mov ebx, 0
    mov ecx, binary5 ; second input , binary5 
    mov edx, 2 ; 1 for the input , 1 for the null terminator 
    int 0x80
    
    sub byte[binary5] , '0' ; change ASCII to numeric 
    ; invalid input ! only 1 and 0 
     cmp byte[binary5], 0 
    jb second_input
     cmp byte[binary5], 1
    ja second_input
    
    cmp byte [option], '4' ; if option is 4 , jump to AND 
    je and1
    cmp byte [option], '5' ; if option is 5 , jump to or 
    je or1
    cmp byte [option], '6' ; if option is 6 , jump to xor 
    je xor1

and1:
; move first binary input and second binary input to eax , ebx 
    mov eax , dword [binary4] 
    mov ebx , dword [binary5]
    and eax , ebx ; perform AND operation 
    mov dword[result],eax ;move the result from eax 
    jmp display 

or1:
; move first binary input and second binary input to eax , ebx 
    mov eax , dword [binary4]
    mov ebx , dword [binary5]
    or eax , ebx  ;perform OR operation 
    mov dword[result],eax 
    jmp display

not1:
; move first binary input to eax 
    mov eax , dword [binary4]
    xor eax ,1  ; PERFORM NOT operation 
    mov dword[result],eax 
    jmp display

xor1:
; mov first binary input and second binary input to eax , ebx 
    mov eax , dword [binary4]
    mov ebx , dword [binary5]
    xor eax , ebx ; PERFORM XOR operation 
    mov dword[result] , eax 
    jmp display
    
display:
add byte[result] ,'0' ; change numeric to ASCII
; display the answer 
    mov eax, 4
    mov ebx, 1
    mov ecx, Bresult 
    mov edx, 14
    int 0x80
; display the result 
    mov eax, 4
    mov ebx, 1
    mov ecx, result ; display the answer 
    mov edx, 1
    int 0x80
    jmp _start
exit:
; exit 
    mov eax, 1 ; call system exit 
    xor ebx, ebx ; ebx is 0 , successfully exit 
    int 0x80