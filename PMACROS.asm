;MACROS
;_________________________________________
;PRNT CHARACHTER WITH ATTRIBUTE
PRINTCHAR MACRO	CHAR,ATTRIB
			PUSH CX
			PUSH AX
			PUSH BX
			
			MOV CX,1
			MOV AH,9
			MOV BH,0
			MOV AL, CHAR
			MOV BL,ATTRIB
			INT 10H
			
			POP BX
			POP AX
			POP CX
ENDM


;_________________________________________
;SET CRUSOR
SCURSOR MACRO  ROW,COLUMN   
    PUSH BX   
    PUSH DX
    PUSH AX
	MOV AH,02
	MOV BH,00
	MOV DL,COLUMN
	MOV DH,ROW   
	INT 10H
	POP AX  
	POP DX  
	POP BX
ENDM


;_________________________________________
;DELAY
DEL MACRO
    PUSH CX
    PUSH AX 
    MOV CX, 0FH
    MOV DX, 4240H
    MOV AH, 86H
    INT 15H
    POP AX
    POP CX
ENDM

;_________________________________________
;DRAWPIXEL
DRAWPIXEL MACRO COL,ROW,COLOR
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

;_________________________________________
;PRINT MESSAGE
PRINTMESSAGE	MACRO MESSAGE
			MOV AH,9H
            MOV DX,OFFSET MESSAGE
            INT 21H
ENDM


;_________________________________________
;DRAWS ANY NEEDED CHARACHTER IN GAME FROM BOTTOM TO TOP
;INPUT SPRITE,START OF X, START OF Y
DRAWSHAPE	MACRO SPRITE,XSTART,YSTART
			LOCAL SHAPEY,SHAPEX
			
			;SAVING START
			MOV AX,XSTART
			MOV X,AX
			
			MOV DI,YSTART
			MOV Y,DI
			
			MOV BX, OFFSET SPRITE
			
			MOV CL,0	;ROWS ->25
SHAPEY:		MOV SI,0	;COLS ->23
			
SHAPEX:		MOV DL,[BX][SI]
			MOV COLOR,DL
			DRAWPIXEL X,Y,COLOR
			INC X
			INC SI
			CMP SI,23
			JNE SHAPEX
			
			;DRAWING NEW ROW
			DEC Y
			MOV AX,XSTART
			MOV X,AX
			
			ADD BX,23
			INC CL
			CMP CL,25
			JNE SHAPEY
			
ENDM


;CLEAR SCREEN
;________________________________________________
CLEARSCREEN MACRO
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV AL,0
	MOV AH,06
	MOV BX,07
	MOV CX,00
	MOV DX,184FH
	INT 10H
	POP DX
	POP CX
	POP BX
	POP AX
ENDM