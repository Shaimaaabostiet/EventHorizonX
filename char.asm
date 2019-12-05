;______________________________________________

DRAWPIXEL MACRO ROW,COL,COLOR
				LOCAL DRAWFINISH
				PUSH CX
				PUSH DX
				PUSH AX
				
				;CHECK IF PIXEL IS ZERO AND IGNORE IT 
				CMP COLOR,00
				JE DRAWFINISH
				MOV CX,COL
				MOV DX,ROW
				MOV AL,COLOR
				MOV AH,0CH
				INT 10H
		
DRAWFINISH:		POP AX
				POP DX
				POP CX
ENDM

;______________________________________________
DRAWFIGURE	MACRO WID,HEIGHT,SPRITE,XSTART,YSTART
			LOCAL SHAPEY,SHAPEX
			
			;SAVING START
			MOV AX,XSTART
			MOV X,AX
			
			MOV DI,YSTART
			MOV Y,DI
			
			MOV BX, OFFSET SPRITE
			
			MOV CL,0	
SHAPEY:		MOV SI,0	
			
SHAPEX:		MOV DL,[BX][SI]
			MOV COLOR,DL
			DRAWPIXEL X,Y,COLOR
			INC Y
			INC SI
			CMP SI,WID
			JNE SHAPEX
			
			;DRAWING NEW ROW
			DEC X
			MOV AX,YSTART
			MOV Y,AX
			
			ADD BX,WID
			INC CL
			CMP CL,HEIGHT
			JNE SHAPEY
			
ENDM		
;______________________________________________


.MODEL	SMALL
.STACK 64
.DATA

;25 ROWS ,23 COLUMNS SPRI
include ship1.inc
include sh2.asm
include heart.inc
	
SHIP1Y	DW 296
SHIP1X	DW 199
	
	
SHIP2X	DW 24
SHIP2Y	DW	0

POWERUPX	DW	160
POWERUPY	DW	100

COLOR DB ?
X 	  DW ?
Y     DW ?	

.CODE

MAIN PROC FAR
			MOV AX,@DATA
			MOV DS,AX
			
			;SWITCH VIDEO MODE
			;200*320
			MOV AH,0
			MOV AL,13H
			INT 10H
			
			DRAWFIGURE 23,25,SHIP1,SHIP1X,SHIP1Y
			DRAWFIGURE 23,25,SHIP2,SHIP2X,SHIP2Y
			DRAWFIGURE 14,11,HEART,POWERUPX,POWERUPY
			
			MOV AH,02
			MOV BH,00
			MOV DL,0
			MOV DH,100  
			INT 10H
			
			
			
EXIT:		MOV AH,4CH
			INT 21h
			
MAIN ENDP
END MAIN