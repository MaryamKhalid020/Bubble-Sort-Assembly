.MODEL SMALL
.STACK 100h

.DATA
    MAX_ELEMENTS EQU 7          ; Number of elements
    ARRAY DB MAX_ELEMENTS DUP(?) ; Array to store numbers
    N EQU MAX_ELEMENTS

    PROMPT_MSG DB 'Enter a byte value (0-255): $'
    ARRAY_SIZE_MSG DB 'Sorting 7 elements...', 0DH, 0AH, '$'
    SORTED_MSG DB 0DH, 0AH, 'Sorted Array is: $'

    DIGIT_BUFFER DB 5 DUP('$')  ; Buffer for printing numbers
    SPACE_CHAR DB ' '
    CRLF DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV CL, N                  ; Loop for input
    MOV SI, 0

    MOV AH, 09h
    LEA DX, ARRAY_SIZE_MSG
    INT 21h

INPUT_LOOP:
    MOV AH, 09h
    LEA DX, PROMPT_MSG
    INT 21h

    CALL READ_AND_CONVERT_BYTE ; Read number into AL
    MOV [ARRAY + SI], AL       ; Store in array
    INC SI

    MOV AH, 09h
    LEA DX, CRLF
    INT 21h

    LOOP INPUT_LOOP

    MOV CL, N
    DEC CL                     ; Outer loop = N-1

OUTER:
    MOV BH, CL
    LEA SI, ARRAY

INNER:
    MOV AL, [SI]
    CMP AL, [SI+1]
    JBE NO_SWAP

    MOV DL, [SI+1]             ; Swap
    MOV [SI+1], AL
    MOV [SI], DL

NO_SWAP:
    INC SI
    DEC BH
    JNZ INNER

    DEC CL
    JNZ OUTER

    MOV AH, 09h
    LEA DX, SORTED_MSG
    INT 21h

    MOV CX, N
    LEA SI, ARRAY

PRINT_LOOP:
    MOV AL, [SI]
    CALL BYTE_TO_ASCII_PRINT   ; Print number

    MOV AH, 02h
    MOV DL, SPACE_CHAR
    INT 21h

    INC SI
    LOOP PRINT_LOOP

    MOV AH, 4CH
    INT 21H
MAIN ENDP

READ_AND_CONVERT_BYTE PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BH, 0                  ; Result
    MOV CL, 3                  ; Max 3 digits

READ_DIGIT:
    MOV AH, 01h
    INT 21h

    CMP AL, 0DH
    JE DONE

    CMP AL, '0'
    JL READ_DIGIT
    CMP AL, '9'
    JG READ_DIGIT

    SUB AL, '0'
    MOV BL, 10
    MOV AL, BH
    MUL BL
    ADD AL, BYTE PTR [SP]      ; Add digit
    MOV BH, AL

    LOOP READ_DIGIT

DONE:
    MOV AL, BH
    POP DX
    POP CX
    POP BX
    RET
READ_AND_CONVERT_BYTE ENDP

BYTE_TO_ASCII_PRINT PROC
    PUSH AX
    PUSH BX
    PUSH DX
    PUSH DI

    MOV AH, 0
    MOV BL, 10
    LEA DI, DIGIT_BUFFER + 4
    MOV BYTE PTR [DI], '$'
    DEC DI

CONVERT:
    DIV BL
    ADD AH, 30h
    MOV [DI], AH
    DEC DI
    MOV AH, 0
    CMP AL, 0
    JNE CONVERT

    INC DI
    MOV AH, 09h
    MOV DX, DI
    INT 21h

    POP DI
    POP DX
    POP BX
    POP AX
    RET
BYTE_TO_ASCII_PRINT ENDP

END MAIN
