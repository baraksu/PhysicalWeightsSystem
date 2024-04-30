.MODEL small
.STACK 100h

.DATA
m1 db 0     ;מייצג את המסה של הגוף השמאלי במערכת
m2 db 0     ;מייצג את המסה של הגוף הימני במערכת  
meu1 db 0   ; מייצג את מקדם החיכוך של הגוף השמאלי במערכת
a db ?      ;מייצג את התאוצה של המערכת
v0 db 0     ;מייצג את המהירות בכל שנייה של המערכת (מתעדכן בכל סיבוב של תנועה של המערכת)

  ;

msg1 db "enter m1 (2 digits):","$"          ;הודעה שמוצגת על המסך לפני קליטת מסה 1
msg2 db 13,10,"enter m2 (2 digits):","$"    ;הודעה שמוצגת על המסך לפני קליטת מסה 2
msg4 db 13,10,"enter meu1 (2 digits):","$"  ;הודעה שמוצגת על המסך לפני קליטת מיו 1
msg3 db "a=<0,No movement will occur","$"   ;הודעה שמוצגת על המסך במקרה שהתאוצה קטנה או שווה ל0
msg5 db 13,10,"invalid input$"               ;הודעה שמוצגת על המסך במקרה והקלט לא תקין

 x_center dw ?         ;של מרכז המעגל X 
 y_center dw ?         ;של מרכז המעגל Y
 y_value dw 0          ;של הנקודה המצוירת Y					
 x_value dw ?          ;רדיוס המעגל
 decision dw 0         ;ההחלטה בכל סיבוב של ציור פיקסל (האם לצייר למעלה או הצידה)
 color db ? ;1=blue    ;צבע הגוף המצויר
 
    x1 dw ?           ;של המרובע הגדול (הבסיס שעליו יושב המרובע הימני)  X 
    y1 dw ?           ;של המרובע הגדול (הבסיס שעליו יושב המרובע הימני)  Y
    w dw ?            ;הרוחב של המרובע הגדול (הבסיס שעליו יושב המרובע הימני)  
    h dw ?            ;הגובה של המרובע הגדול (הבסיס שעליו יושב המרובע הימני) 
    
    xline dw ?        ;(משתנה בהתאם לאורך החבל בכל סיבוב של הלולאה) של "החבל" שמחבר בין המסה השמאלית לגלגלת X 
    yline dw ?        ;של "החבל" שמחבר בין המסה השמאלית לגלגלת Y
    wline dw ?        ;(משתנה בהתאם לאורך החבל בכל סיבוב של הלולאה) אורך "החבל" שמחבר בין המסה השמאלית לגלגלת 
    
    xcolumn dw ?      ;של "החבל" שמחבר בין המסה הימנית לגלגלת X 
    ycolumn dw ?      ;(משתנה בהתאם לאורך החבל בכל סיבוב של הלולאה) של "החבל" שמחבר בין המסה הימנית לגלגלת Y
    hcolumn dw ?      ;(משתנה בהתאם לאורך החבל בכל סיבוב של הלולאה) אורך "החבל" שמחבר בין המסה השמאלית לגלגלת 
    
    xleft_square dw ? (משתנה בהתאם למיקום הגוף בכל סיבוב של הלולאה) ;של המסה השמאלית X 
    yleft_square dw ? ;של המסה השמאלית Y 
    wleft_square dw ? ;אורך המסה השמאלית 
    hleft_square dw ? ;גובה המסה השמאלית  
    
    xright_square dw ? ;של המסה הימנית X 
    yright_square dw ? ;(משתנה בהתאם למיקום הגוף בכל סיבוב של הלולאה) של המסה הימנית Y 
    wright_square dw ? ;אורך המסה הימנית 
    hright_square dw ? ;גובה המסה הימנית  
    
    TempW dw ?        ;
    pointX dw ?       ;
    pointY dw ?       ;
    point1X dw ?      ;נקודת ההתחלה של הקו הישר X
    point1Y dw ?      ;נקודת ההתחלה של הקו הישר Y
    point2X dw ?      ;נקודת הסיום של הקו הישר X
    point2Y dw ?      ;נקודת הסיום של הקו הישר Y
    
    x dw ?            ;(משתנה בהתאם לחישוב המרחק בכל סיבוב של הלולאה) משתנה שמייצג מה המרחק שהגופים צריכים לעבור בכל סיבוב של הלולאה
.CODE
	

drawline proc
;color,wline,;yline,xline:טענת כניסה
;טענת יציאה:הפונקציה מציירת קו ישר בהתאם לפרמטרים שהוכנסו אליה
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
;color,wcolumn,;ycolumn,xcolumn:טענת כניסה
;טענת יציאה:הפונקציה מציירת עמודה ישרה בהתאם לפרמטרים שהוכנסו אליה
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
;color,decision,y_value,x_value,y_center,x_center:טענת כניסה
;טענת יציאה:הפונקציה מציירת עיגול בהתאם לפרמטרים שהוכנסו אליה
push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP   
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
pop bp
ret
 circle endp 
 
  blank_square proc  
  ;אורך צלע הריבוע, גובה הריבוע,קודקוד ימני עליון של הריבוע y,קודקוד ימני עליון של הריבוע x:טענת כניסה 
  ;טענת יציאה:הפונקציה מציירת ריבוע חלול בהתאם לפרמטרים שהוכנסו אליה
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
    push BP     ; save BP on stack
    mov BP, SP  ; set BP to current SP  
    
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
	pop bp
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
    mov cx,2         ;show msg1
input_m1:
	mov ah, 01h
	int 21h
	cmp al,30h
    jb error2
    cmp al,39h 
    ja error2
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
    mov cx,2          ;show msg1
input_m2:
	mov ah, 01h
	int 21h
	cmp al,30h
    jb error2
    cmp al,39h 
    ja error2
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
    mov cx,2          ;show msg4
input_meu1:                                
	mov ah, 01h
	int 21h
	cmp al,30h
    jb error2
    cmp al,39h 
    ja error2
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
    mov cx,ax
    mov al,m1
    mul bl
    mov bl,meu1
    xor bh,bh
    mul bx
    cmp ax,cx
    ja minus
    sub cx,ax
    mov ax,cx
    mov bl,m1
    add bl,m2
    div bl
    mov a,al

    jmp drawing
minus:
mov a,0    
    

    
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
   
   mov [xleft_square], 11
   mov [yleft_square], 80
   mov [wleft_square],40
   mov [hleft_square],19
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   call blank_square 
      
   mov [xright_square],210
   mov [yright_square],110
   mov [wright_square],40
   mov [hright_square],19
   push xright_square
   push yright_square
   push wright_square
   push hright_square
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
    
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   mov [color],0h 
   call blank_square
   mov ax,x
   xor ah,ah
   add xleft_square,ax
   push xleft_square
   push yleft_square
   push wleft_square
   push hleft_square
   mov [color],14 
   call blank_square 
   
   
   push xright_square
   push yright_square
   push wright_square
   push hright_square
   mov [color],0h 
   call blank_square
   
   mov ax,x
   add yright_square,ax
   push xright_square
   push yright_square
   push wright_square
   push hright_square
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
   xor ah,ah
   mov bl,2
   div bl
   xor ah,ah
   add al,v0
   add ax,yright_square
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
    jmp exit
error2:
    lea dx, msg5
    mov ah, 09h
    int 21h 
exit:      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start

 
         
         

