section .data
    target_number db 0            ; Target number to be guessed
    user_input db 10              ; Buffer to store user input
    user_guess db ?               ; User's guess
    msg_welcome db "Welcome to the Number Guessing Game!", 0xA, 0xD
    len_welcome equ $ - msg_welcome
    msg_instructions db "Guess a number between 1 and 100:", 0xA, 0xD
    len_instructions equ $ - msg_instructions
    msg_low db "Too low! Try again.", 0xA, 0xD
    len_low equ $ - msg_low
    msg_high db "Too high! Try again.", 0xA, 0xD
    len_high equ $ - msg_high
    msg_congrats db "Congratulations! You guessed the number.", 0xA, 0xD
    len_congrats equ $ - msg_congrats

section .text
    global _start

_start:
    ; Print welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_welcome
    mov edx, len_welcome
    int 80h

    ; Generate a random number between 1 and 100
    mov eax, 42                   ; syscall number for SYS_getrandom
    mov edi, target_number        ; pointer to where random bytes should be stored
    mov esi, 1                    ; number of bytes to generate
    mov edx, esi                  ; size of buffer
    xor ebx, ebx                  ; flags (none)
    syscall

    and byte [target_number], 0x7F  ; ensure the number is positive
    movzx eax, byte [target_number] ; load the random number

    add eax, 1                    ; adjust random number to be between 1 and 100
    mov [target_number], al

    ; Print instructions
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_instructions
    mov edx, len_instructions
    int 80h

guess_loop:
    ; Read user input
    mov eax, 3
    mov ebx, 0
    mov ecx, user_input
    mov edx, 10
    int 80h

    ; Convert user input to integer
    movzx eax, byte [user_input]
    sub eax, '0'
    mov [user_guess], al

    ; Check if user guessed correctly
    cmp al, [target_number]
    je congrats

    ; Check if guess is too low
    jb low_guess

    ; Guess is too high
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_high
    mov edx, len_high
    int 80h
    jmp guess_loop

low_guess:
    ; Guess is too low
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_low
    mov edx, len_low
    int 80h
    jmp guess_loop

congrats:
    ; Congratulate user for guessing correctly
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_congrats
    mov edx, len_congrats
    int 80h

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 80h
