.MODEL small
.STACK 100h

.DATA
m1 db ?
m2 db ?
t1 db ?
meu1 db ?
msg1 db "enter m1 (2 digits):","$"
msg2 db 13,10,"enter m2 (2 digits):","$"
msg3 db 13,10,"enter t1 (2 digits):","$"
msg4 db 13,10,"enter meu1 (2 digits):","$"


.CODE        

start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
    
    lea dx, msg1
    mov ah, 09h
    int 21h         ;show msg1

	mov ah, 01h
	int 21h
	sub al,30h
    mov bl,10
    mul bl
    mov m1,al    ;input tens number m1
    mov ah, 01h
	int 21h
	sub al,30h
	add m1,al	  ;input units number m1
    
    lea dx, msg2
    mov ah, 09h
    int 21h         ;show msg1

	mov ah, 01h
	int 21h
	sub al,30h
    mov bl,10
    mul bl
    mov m2,al    ;input tens number m2
    mov ah, 01h
	int 21h
	sub al,30h
	add m2,al	  ;input units number m2
	

    lea dx, msg3
    mov ah, 09h
    int 21h         ;show msg3

	mov ah, 01h
	int 21h
	sub al,30h
    mov bl,10
    mul bl
    mov t1,al    ;input tens number t1
    mov ah, 01h
	int 21h
	sub al,30h
	add t1,al	  ;input units number t1
	
	lea dx, msg4
    mov ah, 09h
    int 21h         ;show msg4

	mov ah, 01h
	int 21h
	sub al,30h
    mov bl,10
    mul bl
    mov meu1,al    ;input tens number meu1
    mov ah, 01h
	int 21h
	sub al,30h
	add meu1,al	  ;input units number meu1
	
		
    
    
    ; exit program
    MOV AH, 4CH
    INT 21H
END start

                   
