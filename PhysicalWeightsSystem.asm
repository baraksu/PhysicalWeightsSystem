.MODEL small
.STACK 100h

.DATA
m1 db 0     ;main vars
m2 db 0
t1 db 0
meu1 db 0
a db ?
v0 db 0
v1 db ?
xx1 db 0
xx2 db ?      ;

msg1 db "enter m1 (3 digit,max number:255):","$"
msg2 db 13,10,"enter m2 (3 digits,max number:255):","$"
msg4 db 13,10,"enter meu1 (3 digits,max number:255):","$"
msg3 db "a=0,No movement will occur","$" 

 x_center dw ?         ;vars of circle
 y_center dw ?
 y_value dw 0
 x_value dw ? ;r
 decision dw 0
 color db ? ;1=blue    ;
 
    x1 dw ?           ;blank circle vars
    y1 dw ?
    w dw ?
    h dw ?            ;
    
    xline dw ?
    yline dw ?
    wline dw ?
    
    xcolumn dw ?
    ycolumn dw ?
    hcolumn dw ?
    
    xright_square dw ?
    yright_square dw ?
    wright_square dw ?
    hright_square dw ?   
    
    xleft_square dw ?
    yleft_square dw ?
    wleft_square dw ?
    hleft_square dw ?  
    
    TempW dw ?        ;diagonal line Vars
    pointX dw ? 
    pointY dw ?
    point1X dw ? 
    point1Y dw ?
    point2X dw ? 
    point2Y dw ?
    
    x dw ?
.CODE
	

drawline proc
        push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP     
    
    mov cx, [bp+8]
    add cx,[bp+4]  ; column
    mov dx, [bp+6]     ; row
    mov al, [color]    
line: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, [bp+8]
    ja line        
    
    POP BP          ; restore BP from stack
    RET 6           ; return from the function and clean up the stack 
drawline endp

drawcolumn proc
            push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP   
    
    mov cx, [bp+8]    ; column
    mov dx, [bp+6]
    add dx,[bp+4]   ; row
    mov al, [color]     ; white
column: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, [bp+6]
    ja column
    
    pop bp
    ret 6
drawcolumn endp

circle proc
 
;==========================
 mov bx, x_value
 mov ax,2
 mul bx
 mov bx,3
 sub bx,ax ; E=3-2r
 mov decision,bx
 
 mov al,color ;color goes in al
 mov ah,0ch
 
drawcircle:
 mov al,color ;color goes in al
 mov ah,0ch
 
 mov cx, x_value ;Octonant 1
 add cx, x_center ;( x_value + x_center,  y_value + y_center)
 mov dx, y_value
 add dx, y_center
 int 10h
; 
 mov cx, x_value ;Octonant 4
 neg cx
 add cx, x_center ;( -x_value + x_center,  y_value + y_center)
 int 10h
; 
 mov cx, y_value ;Octonant 2
 add cx, x_center ;( y_value + x_center,  x_value + y_center)
 mov dx, x_value
 add dx, y_center
 int 10h
; 
 mov cx, y_value ;Octonant 3
 neg cx
 add cx, x_center ;( -y_value + x_center,  x_value + y_center)
 int 10h
; 
 mov cx, x_value ;Octonant 8
 add cx, x_center ;( x_value + x_center,  -y_value + y_center)
 mov dx, y_value
 neg dx
 add dx, y_center
 int 10h
; 
 mov cx, x_value ;Octonant 5
 neg cx
 add cx, x_center ;( -x_value + x_center,  -y_value + y_center)
 int 10h

 mov cx, y_value ;Octonant 7
 add cx, x_center ;( y_value + x_center,  -x_value + y_center)
 mov dx, x_value
 neg dx
 add dx, y_center
 int 10h
 
 mov cx, y_value ;Octonant 6
 neg cx
 add cx, x_center ;( -y_value + x_center,  -x_value + y_center)
 int 10h
 


condition1:
 cmp decision,0
 jg condition2      
 ;e<0
 mov cx, y_value
 mov ax, 2
 imul cx ;2y
 add ax, 3 ;ax=2y+3
 mov bx, 2
 mul bx  ; ax=2(2y+3)
 add decision, ax
 mov bx, y_value
 mov dx, x_value
 cmp bx, dx
 ja end  
 inc y_value
 jmp drawcircle

condition2:
 ;e>0
 mov cx, y_value 
 mov ax,2
 mul cx  ;cx=2y
 mov bx,ax
 mov cx, x_value
 mov ax, -2
 imul cx ;cx=-2x
 add bx,ax
 add bx,5;bx=5-2z+2y
 mov ax,2
 imul bx ;ax=2(5-2z+2y)       
 add decision,ax
 mov bx, y_value
 mov dx, x_value
 cmp bx, dx
 ja end
 dec x_value
 inc y_value
 jmp drawcircle


 
end:
ret
 circle endp 
 
  blank_square proc  
    
    push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP     
     
    mov cx, [bp+10]
    add cx,[bp+6]  ; column
    mov dx, [bp+8]     ; row
    mov al, [color]    
u1: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, [bp+10]
    ja u1
 
; draw bottom line:

    mov cx, [bp+10]
    add cx,[bp+6]  ; column
    mov dx, [bp+8]
    add dx,[bp+4]   ; row
    mov al, [color]     ; white
u2: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, [bp+10]
    ja u2
 
; draw left line:

    mov cx, [bp+10]    ; column
    mov dx, [bp+8]
    add dx,[bp+4]   ; row
    mov al, [color]     ; white
u3: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, [bp+8]
    ja u3 
    
    
; draw right line:

    mov cx, [bp+10]
    add cx,[bp+6]  ; column
    mov dx, [bp+8]
    add dx,[bp+4]   ; row
    mov al, [color]     ; white
u4: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, [bp+8]
    ja u4
         
    POP BP          ; restore BP from stack
    RET 8           ; return from the function and clean up the stack 
    blank_square endp
  
  
Macro DrawLine2DDY p1X, p1Y, p2X, p2Y
	local l1, lp, nxt
	mov dx, 1
	mov ax, [p1X]
	cmp ax, [p2X]
	jbe l1
	neg dx ; turn delta to -1
l1:
	
	mov ax, [p1X]
	mov [pointX], ax
	mov ax, [p1Y]
	mov [pointY], ax
	mov bx, [p2Y]
	sub bx, [p1Y]
	absolute bx
	mov cx, [p2X]
	sub cx, [p1X]
	absolute cx
	
	mov ax, [p2Y]
	shr ax, 1 ; div by 2 
	neg ax
	add ax,bx
	mov [TempW], ax
	
	mov ax, [p2Y]
lp:
	pusha
	call PIXEL
	popa
	inc [pointY]
	cmp [TempW], 0
	jl nxt
	sub [TempW], bx ; bx = (p2Y - p1Y) = deltay
	add [pointX], dx ; dx = delta
nxt:
	add [TempW], cx ; cx = abs(p2X - p1X) = daltax
	cmp [pointY], ax ; ax = p2Y
	jne lp
	call PIXEL
ENDM DrawLine2DDY
;---------------------------------------------
; case: DeltaX is bigger than DeltaY		  
; input: p1X p1Y,		            		  
; 		 p2X p2Y,		           		      
;		 Color -> variable                    
; output: line on the screen                  
;---------------------------------------------
Macro DrawLine2DDX p1X, p1Y, p2X, p2Y
	local l1, lp, nxt
	
	
	
	mov dx, 1
	mov ax, [point1Y]
	cmp ax, [point2Y]
	jbe l1
	neg dx ; turn delta to -1
l1:
	
	mov ax, [point1X]
	mov [pointX], ax
	mov ax, [point1Y]
	mov [pointY], ax
	mov bx, [point2X]
	sub bx, [point1X]
	absolute bx
	mov cx, [point2Y]
	sub cx, [point1Y]
	absolute cx    
	
	
	mov ax, bx
	shr ax, 1 ; div by 2
	neg ax
	add ax,cx
	
	mov [TempW], ax
	
	mov ax, [point2X]
lp:
	pusha
	call PIXEL
	popa
	inc [pointX]
	cmp [TempW], 0
	jl nxt
	sub [TempW], bx ; bx = abs(p2X - p1X) = deltax
	add [pointY], dx ; dx = delta
nxt:
	add [TempW], cx ; cx = abs(p2Y - p1Y) = deltay
	cmp [pointX], ax ; ax = p2X
	jne lp
	call PIXEL
	
	
ENDM DrawLine2DDX
Macro absolute a
	local l1
	cmp a, 0
	jge l1
	neg a
l1:
Endm
.MODEL small

; procedures
;---------------------------------------------
; input: point1X point1Y,         
; 		 point2X point2Y,         
;		 Color                        
; output: line on the screen                  
;---------------------------------------------
PROC DrawLine2D
	mov cx, [point1X]
	sub cx, [point2X]
	absolute cx
	mov bx, [point1Y]
	sub bx, [point2Y]
	absolute bx
	cmp cx, bx
	jae DrawLine2Dp1 ; deltaX > deltaY
	mov ax, [point1X]
	mov bx, [point2X]
	mov cx, [point1Y]
	mov dx, [point2Y]
	cmp cx, dx
	jbe DrawLine2DpNxt1 ; point1Y <= point2Y
	xchg ax, bx
	xchg cx, dx
DrawLine2DpNxt1:
	mov [point1X], ax
	mov [point2X], bx
	mov [point1Y], cx
	mov [point2Y], dx
	DrawLine2DDY point1X, point1Y, point2X, point2Y
	ret
DrawLine2Dp1:
	mov ax, [point1X]
	mov bx, [point2X]
	mov cx, [point1Y]
	mov dx, [point2Y]
	cmp ax, bx
	jbe DrawLine2DpNxt2 ; point1X <= point2X
	xchg ax, bx
	xchg cx, dx
DrawLine2DpNxt2:
	mov [point1X], ax
	mov [point2X], bx
	mov [point1Y], cx
	mov [point2Y], dx
	DrawLine2DDX point1X, point1Y, point2X, point2Y
	
	
	
	

	
	
	
	
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
ENDP DrawLine2D
;-----------------------------------------------
; input: pointX pointY,      			
;           Color				
; output: point on the screen			
;-----------------------------------------------
PROC PIXEL
	mov bh,0h
	mov cx,[pointX]
	mov dx,[pointY]
	mov al,[Color]
	mov ah,0Ch
	int 10h
	ret
ENDP PIXEL

 




start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
    
    lea dx, msg1
    mov ah, 09h
    int 21h
    mov cx,3         ;show msg1
input_m1:
	mov ah, 01h
	int 21h
	sub al,30h
	mov dl,al
	mov al,byte ptr m1
    mov bl,10
    mul bl
    xor ah,ah
    add ax,dx
    mov m1,al
    loop input_m1
    
output_m2:    
    lea dx, msg2
    mov ah, 09h
    int 21h
    mov cx,3          ;show msg1
input_m2:
	mov ah, 01h
	int 21h
	sub al,30h
	mov dl,al
	mov al,byte ptr m2
    mov bl,10
    mul bl
    xor ah,ah
    add ax,dx
    mov m2,al
    loop input_m2
	
output_meu1:	
	lea dx, msg4
    mov ah, 09h
    int 21h
    mov cx,3          ;show msg4
input_meu1:                                
	mov ah, 01h
	int 21h
	sub al,30h
	mov dl,al
	mov al,byte ptr meu1
    mov bl,10
    mul bl
    xor ah,ah
    add ax,dx
    mov meu1,al
    loop input_meu1
	
    mov al,m2
    mov bl,10
    mul bl
    mov dl,al
    mov al,m1
    mul bl
    mov bl,meu1
    mul bl
    sub dl,al
    mov al,dl
    mov bl,m1
    add bl,m2
    idiv bl
    mov a,al
    
    mov al,10
    sub al,a
    mov bl,m2
    mul bl
    mov t1,al
    
    
    

    
    drawing:
     mov ah,0 ;subfunction 0
    mov al,13H ;select mode 13h 
    int 10h ;call graphics interrupt
    
    mov [x_center],230
    mov [y_center],90 
    mov [x_value],7  ;radius 
    mov [y_value],0
    mov [color],14
    call circle
 
   mov [x1], 0
   mov [y1], 100
   mov [w],200
   mov [h],99
   push x1
   push y1
   push w
   push h
   call blank_square 
 
	mov [point1X], 230
	mov [point2X], 200
	mov [point1Y], 90
	mov [point2Y], 100
	call DrawLine2D
    
   mov [xline], 50
   mov [yline], 90
   mov [wline],180 
   push xline
   push yline
   push wline
   call drawline
    
   mov [xcolumn], 230
   mov [ycolumn], 90
   mov [hcolumn],20
      push xcolumn
   push ycolumn
   push hcolumn
   call drawcolumn   
   
   mov [xright_square], 11
   mov [yright_square], 80
   mov [wright_square],40
   mov [hright_square],19
   push xright_square
   push yright_square
   push wright_square
   push hright_square
   call blank_square 
      
   mov [xleft_square],210
   mov [yleft_square],110
   mov [wleft_square],40
   mov [hleft_square],19
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   call blank_square
   
   Redraw:
    ; is key press    
    mov ah,01h
    int 16h
    
    jz Redraw
    ; Get the pressed key
    mov ah,00h
    int 16h
    cmp ah,39h
    jne Redraw 
;-------------------------------------------------
cmp a,0
je error1
moving:
   mov al,a
   mov bl,2
   xor ah,ah
   div bl
   add al,v0
   mov byte ptr x,al
   push xline
   push yline
   push wline
   mov [color],0h
   call drawline
   
      mov dx,x 
   add xline,dx
   sub wline,dx
   push xline
   push yline
   push wline 
   mov [color],14
   call drawline 
    
   push xright_square
   push yright_square
   push wright_square
   push hright_square
   mov [color],0h 
   call blank_square
   mov ax,x
   xor ah,ah
   add xright_square,ax
   push xright_square
   push yright_square
   push wright_square
   push hright_square
   mov [color],14 
   call blank_square 
   
   
   
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   mov [color],0h 
   call blank_square
   
   mov ax,x
   add yleft_square,ax
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   mov [color],14 
   call blank_square
   
   mov ax,x
   add hcolumn,ax
   push xcolumn
   push ycolumn
   push hcolumn
   call drawcolumn   
   mov al,a
   add v0,al
   mov al,a
   mov bl,2
   xor ah,ah
   div bl
   xor ah,ah
   add al,v0
   add ax,yleft_square
   cmp ax,191
   jb moving    
   jmp exit
   
error1:   
   	mov al, 13h
	mov ah, 3
	int 10h
	
	lea dx, msg3
    mov ah, 09h
    int 21h 
exit:      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start

                   

         

