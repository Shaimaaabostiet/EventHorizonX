INCLUDE PMACROS.ASM

.MODEL	SMALL
.STACK 64
.DATA

;MAX NUMBER FOR EACH OBSTACLES IS 5
OBSTACLES_COUNT	DB  0
OBSTACLES_ARRAY	DB	60 DUP (0)

TIMESTEP DB 1
COL		 DW ?
OBST 	 DB ?
RANDOMVAR DB ? 
.CODE

;GENERATES RANDOM X,Y,OBSTACLE ACCORDING TO CURRENT TIMESTEP FROM EQN : 4*(X^2+4)/3 MOD SELECTED ITEM
GENERATEOBSTACLE PROC
			
			MOV AL,TIMESTEP
			MUL AL
			ADD AX,4
			MOV BX,4
			XCHG AX,BX
			MUL BX
			
			MOV BL,3
			DIV BL
			MOV RANDOMVAR,AL
			
			MOV BX,OFFSET OBSTACLES_COUNT
			MOV DX,[BX]
			CMP DX,15
			JE OEND
			
			;GETTING OBSTACLE TYPE
			;0 1ST , 1 2ND , 2 3RD
			;AL HAS RANDOM VARIABLE 
			INC byte ptr [BX]	;INCREMENTING OBSTACLES COUNT
			
			;FINDING FIRST EMPTY PLACE
			INC BX
FINDPLACE:	CMP byte ptr [BX],0
			JE EMPTYPLACE
			;ELSE ADD 4 TO CHECK NEXT PLACE
			ADD BX,4
			JMP FINDPLACE
			
EMPTYPLACE:	MOV AH, 0
			MOV CL,3
			DIV CL
			
			CMP AH,0
			JNE OBS2
			MOV byte ptr [BX],'@'
			JMP GETOBSROW
			
OBS2:		CMP AH,1
			JNE	OBS3
			MOV byte ptr [BX],02
			JMP GETOBSROW
			
OBS3:		MOV byte ptr [BX],0FEH
			
			
			
			;GETTING ROW
GETOBSROW:	INC BX
			MOV AL,RANDOMVAR
			MOV CL,2
			DIV CL	;AH CONTAINS REM
			
			CMP AH,0
			JNE SOUTH
			MOV byte ptr [BX],0
			MOV byte ptr [BX]+2,0
			JMP GETOBSCOL
			
SOUTH:		MOV byte ptr[BX],24
			MOV byte ptr[BX]+2,1
			
			
			;GETTING COLUMN
GETOBSCOL:	INC BX
            MOV AL,RANDOMVAR
			MOV CL,80
			DIV CL
			MOV [BX],AH
			
OEND:		RET
GENERATEOBSTACLE ENDP

;_____________________________________________________________
;DRAWOSBTACLES PROC
DRAWOSBTACLES PROC	
			PUSH CX
			
			MOV CX,15
			MOV BX,OFFSET OBSTACLES_ARRAY

DRAWLOOP:	MOV DL,[BX]
			CMP DL,0
			JE NEXT
			SCURSOR	[BX]+1,[BX]+2
			PRINTCHAR [BX],04
			
NEXT:		ADD BX,4
			LOOP DRAWLOOP

			RET
DRAWOSBTACLES ENDP

MAIN PROC FAR
			MOV AX,@DATA
			MOV DS,AX
			
			;SWITCH VIDEO MODE
			MOV AH,0
			MOV AL,13H
			INT 10H
			
			MOV CX,100
INFLOOP:	CALL GENERATEOBSTACLE
			CALL DRAWOSBTACLES
			
			ADD TIMESTEP, 1
			DEL
			LOOP INFLOOP
			
EXIT:		MOV AH,4CH
			INT 21h
			
MAIN ENDP
END MAIN