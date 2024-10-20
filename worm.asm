;Hayden Cameron
;04/19/2023
;LC3 Program 3(worm.asm):	This program moves a 4x4 box from the wasd inputs. The box will also change color from the
;							rgby & "space" inputs. Additionally, the box will automatically change color every 5 moves
;							and leaves a trail. The box will stay within the boundaries of the display and print: 
;							"WORMS CAN'T LEAVE!" if the box recieves an input to go past the boundary. "Enter" resets
;							the program & q halts the program.									
			.ORIG x3000
RESET							;Preps registers to paint the screen black
			LD R6, STARTxy
			AND R5, R5, #0
			LD R4, SCREEN_TOT
			ST R5, x_counter
			ST R5, y_counter
PAINT_TOT						;Paints every pixel black
			STR R5, R6, #0
			ADD R6, R6, #1
			ADD R4, R4, #-1
			BRp PAINT_TOT
START_PEN						;Sets the starting pen location
			LD R6, STARTPENxy
			ST R6, PENxy
			LD R5, WHITE
			ST R5, COLOR		
			LD R4, STARTCOL_DIFF
			ST R4, COL_DIFF
SET_MOVE_CNT		
			LD R3, NUM0
			ST R3, MOVE_COUNT
SET_PEN							;Sets the across and down counters 
			LD R4, NUM4
			LD R3, NUM4
PAINT_PEN						;Paints the 4x4 pen at whatever location and color it is
			LD R5, COLOR
			STR R5, R6, #0
ACROSS_PEN
			ADD R6, R6, #1
			ADD R4, R4, #-1
			BRp PAINT_PEN
			LD R4, NUM4
DOWN_PEN
			LD R2, NUM124
			ADD R6, R6, R2
			ADD R3, R3, #-1
			BRp PAINT_PEN
RESET_PEN
			LD R5, SUB512
			ADD R6, R6, R5
			ST R6 PENxy
INPUT							;Grabs the Keyboard input
			GETC
			JSR MOVE_INPUTS		;4 JSR's for the input (admitadly kinda pointless, but for the grade ;)
			JSR COLOR_INPUTS
			JSR RESET_INPUT
			JSR QUIT_INPUT
			BRnzp INPUT
			
MOVE_INPUTS			
			LD R1, SUB119		;Checks for w input
			ADD R1, R1, R0
			BRz w_INPUT
			
			LD R1, SUB97		;Checks for a input
			ADD R1, R1, R0
			BRz a_INPUT
			
			LD R1, SUB115		;Checks for s input
			ADD R1, R1, R0
			BRz s_INPUT
			
			LD R1, SUB100		;Checks for d input
			ADD R1, R1, R0
			BRz d_INPUT
			RET
COLOR_INPUTS			
			LD R1, SUB114		;Checks for r input
			ADD R1, R1, R0
			BRz r_INPUT
			
			LD R1, SUB103		;Checks for g input
			ADD R1, R1, R0
			BRz g_INPUT
			
			LD R1, SUB98		;Checks for b input
			ADD R1, R1, R0
			BRz b_INPUT
			
			LD R1, SUB121		;Checks for y input
			ADD R1, R1, R0
			BRz y_INPUT
			
			LD R1, SUB32		;Checks for "space" input
			ADD R1, R1, R0
			BRz space_INPUT
			RET
RESET_INPUT			
			LD R1, SUB10		;Checks for "enter" input
			ADD R1, R1, R0
			BRz enter_INPUT
			RET
QUIT_INPUT			
			LD R1, SUB113		;Checks for q input
			ADD R1, R1, R0
			BRz q_INPUT
			RET
w_INPUT	
			LD R1, y_counter	;Checks if y is 15
			AND R2, R2, #0
			ADD R2, R1, #-15
			Brz NONO
			
			ADD R1, R1, #1		;Updates y counter
			ST R1, y_counter
			
			JSR MOVE_CHECK		;5th JSR that checks the move count and changes the color automatically
			
			LD R1, UP_xy		;Moves pen location up
			ADD R6, R6, R1
			BRnzp SET_PEN
a_INPUT	
			LD R1, x_counter	;Checks if x is -16
			LD R2, NUM16
			ADD R2, R2, R1
			Brz NONO
			
			ADD R1, R1, #-1		;Updates x counter
			ST R1, x_counter
			
			JSR MOVE_CHECK		;5th JSR that checks the move count and changes the color automatically
			
			LD R1, LEFT_xy		;Moves pen location left
			ADD R6, R6, R1	
			BRnzp SET_PEN
s_INPUT	
			LD R1, y_counter	;Checks if y is -15
			AND R2, R2, #0
			ADD R2, R1, #15
			Brz NONO
			
			ADD R1, R1, #-1		;Updates y counter
			ST R1, y_counter
			
			JSR MOVE_CHECK		;5th JSR that checks the move count and changes the color automatically
			
			LD R1, DOWN_xy		;Moves pen location down
			ADD R6, R6, R1
			BRnzp SET_PEN
d_INPUT	
			LD R1, x_counter	;Checks if x is 14
			AND R2, R2, #0
			ADD R2, R1, #-15
			Brz NONO
			
			ADD R1, R1, #1		;Updates x counter
			ST R1, x_counter
			
			JSR MOVE_CHECK		;5th JSR that checks the move count and changes the color automatically
			
			LD R1, RIGHT_xy		;Moves pen location right
			ADD R6, R6, R1
			BRnzp SET_PEN
			
r_INPUT	
			LD R5, RED			;Changes color to red and sets coler difference
			ST R5, Color
			LD R5, NUM1
			ST R5, COL_DIFF
			BRnzp SET_MOVE_CNT
g_INPUT	
			LD R5, GREEN		;Changes color to green and sets coler difference
			ST R5, Color
			LD R5, NUM2
			ST R5, COL_DIFF
			BRnzp SET_MOVE_CNT
b_INPUT	
			LD R5, BLUE			;Changes color to blue and sets coler difference
			ST R5, Color
			LD R5, NUM3
			ST R5, COL_DIFF
			BRnzp SET_MOVE_CNT
y_INPUT
			LD R5, YELLOW		;Changes color to yellow and sets coler difference
			ST R5, Color
			LD R5, NUM4
			ST R5, COL_DIFF
			BRnzp SET_MOVE_CNT
space_INPUT	
			LD R5, WHITE		;Changes color to white and sets coler difference
			ST R5, Color
			LD R5, NUM0
			ST R5, COL_DIFF
			BRnzp SET_MOVE_CNT
enter_INPUT	
			BRnzp RESET			;Resets program
q_INPUT	
			HALT				;Halts program
NONO
			LEA R0, NONO_PROMPT	;Prints cant leave prompt
			PUTS
			BRnzp INPUT
MOVE_CHECK
			LD R1, MOVE_COUNT	;Checks if move counter is 5
			LD R2, SUB4
			ADD R1, R1, #1
			ST R1, MOVE_COUNT
			ADD R2, R2, R1
			BRp COLOR_CHANGE
			RET
COLOR_CHANGE
			ADD R1, R1, #-5		;Resets move counter
			ST R1, MOVE_COUNT
			
			LD R1, COL_DIFF		;Sets color difference to 0 or adds one if counter is 4 or not
			LD R2, SUB4
			ADD R1, R1, R2
			BRz STORE
			ADD R1, R1, #5
STORE			
			ST R1, COL_DIFF
			
			LEA R5, WHITE		;Sets proper color acocrding to color difference
			ADD R5, R5, R1
			LDR R5, R5, #0
			ST R5, COLOR
			RET

STARTPENxy .FILL xDE40		;location related labels
PENxy .FILL xDE40			
STARTxy .FILL xC000
SCREEN_TOT .FILL x3DFF
y_counter .FILL #0
x_counter .FILL #0
UP_xy .FILL #-512
LEFT_xy .FILL #-4
DOWN_xy .FILL #512
RIGHT_xy .FILL #4
MOVE_COUNT .FILL #0

NUM124 .FILL #124			;Positive value labels
NUM4 .FILL #4
NUM16 .FILL #16
NUM0 .FILL #0
NUM1 .FILL #1
NUM2 .FILL #2
NUM3 .FILL #3

SUB119 .FILL #-119			;Negative value labels
SUB97 .FILL #-97
SUB115 .FILL #-115
SUB100 .FILL #-100
SUB114 .FILL #-114
SUB103 .FILL #-103
SUB98 .FILL #-98
SUB121 .FILL #-121
SUB32 .FILL #-32
SUB10 .FILL #-10
SUB113 .FILL #-113
SUB512 .FILL #-512
SUB4 .FILL #-4

NONO_PROMPT .STRINGZ "WORMS CAN'T LEAVE!\n"	;String labels

COLOR .FILL xFFFF			;Color related labels
WHITE .FILL xFFFF
RED .FILL x7C00
GREEN .FILL x03E0
BLUE .FILL x001F
YELLOW .FILL x7FE0
STARTCOL_DIFF .FILL #0
COL_DIFF .FILL #1

.END