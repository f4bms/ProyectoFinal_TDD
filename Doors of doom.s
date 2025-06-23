main:
    MOV R0, #0
    LDR R1, =0x1000       @ Reset entrada jugador 1
    STR R0, [R1]
    LDR R1, =0x2000       @ Reset entrada jugador 2
    STR R0, [R1]
    LDR R1, =0x3000       @ Reset entrada número temporizador 
    STR R0, [R1]
    LDR R1, =0x4000       @ Reset entrada número aleatorio
    STR R0, [R1]
    LDR R1, =0x8000       @ Reset Salida número puertas
    STR R0, [R1]
    LDR R1, =0x9000       @ Salida posicion del jugador 1
    STR R0, [R1]
    LDR R1, =0x10000       @ Salida posicion del jugador 2
    STR R0, [R1]
    MOV R0, #3
    LDR R1, =0x6000       @ Salida Vidas jugador 1
    STR R0, [R1]
    LDR R1, =0x7000       @Salida Vidas jugador 2
    STR R0, [R1]
game_loop:
    LDR R0, =0x1000       @ Entrada jugador 1
	LDR R1, [R0]
	CMP R1, #1
	BNE izquierda_p1         @ Esperar a que llegue a 0
    LDR R0, =0x9000       @ Dirección vidas jugador 2
    LDR R8, [R0]
	CMP R8, #3
    BEQ izquierda_p1
    ADD R8, R8, #1
    STR R8, [R0]
izquierda_p1:
    LDR R0, =0x1000       @ Entrada jugador 1
	LDR R1, [R0]
	CMP R1, #2
    BNE Derecha_p2   
    LDR R0, =0x9000       @ Dirección vidas jugador 2
    LDR R8, [R0]
	CMP R8, #0
    BEQ Derecha_p2
    SUB R8, R8, #1
    STR R8, [R0]
Derecha_p2:
    LDR R0, =0x2000       @ Entrada jugador 1
	LDR R1, [R0]
	CMP R1, #1
    BNE izquierda_p2   
    LDR R0, =0x10000       @ Dirección psicion jugador
    LDR R9, [R0]
	CMP R9, #3
    BEQ izquierda_p2
    ADD R9, R9, #1
    STR R9, [R0]
izquierda_p2:
	LDR R0, =0x2000       @ Entrada jugador 1
	LDR R1, [R0]
	CMP R1, #2
    BNE skip_moves   
    LDR R0, =0x10000       @ Dirección psicion jugador
    LDR R9, [R0]
	CMP R9, #0
    BEQ skip_moves
    SUB R9, R9, #1
    STR R9, [R0]
skip_moves:
    LDR R1, =0x1000       @ Entrada jugador 1
    LDR R2, =0x2000       @ Entrada jugador 2
    LDR R4, =0x4000       @ Dirección del número aleatorio
    LDR R3, =0x3000       @ Dirección del temporizado
    LDR R5, [R3]          @ Leer temporizador
    CMP R5, #1
    BNE game_loop         @ Esperar a que llegue a 1
    LDR R10, [R4]         @ Número aleatorio (0 a 5) @ Obtener las dos puertas correctas según el número aleatorio
    CMP R10, #0
    BEQ correct_12
    CMP R10, #1
    BEQ correct_13
    CMP R10, #2
    BEQ correct_14
    CMP R10, #3
    BEQ correct_23
    CMP R10, #4
    BEQ correct_24
    CMP R10, #5
    BEQ correct_34
correct_12:
    MOV R11, #0
    MOV R12, #1
    MOV R0, #0xC               @ binario 1100 = puertas 1 y 2
    LDR R1, =0x8000            @ dirección fija para guardar info de puertas correctas
    STR R0, [R1]
    B check_players
correct_13:
    MOV R11, #0
    MOV R12, #2
    MOV R0, #0xA               @ binario 1010 = puertas 1 y 3
    LDR R1, =0x8000
    STR R0, [R1]
    B check_players
correct_14:
    MOV R11, #0
    MOV R12, #3
    MOV R0, #0x9               @ binario 1001 = puertas 1 y 4
    LDR R1, =0x8000
    STR R0, [R1]
    B check_players
correct_23:
    MOV R11, #1
    MOV R12, #2
    MOV R0, #0x6               @ binario 0110 = puertas 2 y 3
    LDR R1, =0x8000
    STR R0, [R1]
    B check_players
correct_24:
    MOV R11, #1
    MOV R12, #3
    MOV R0, #0x5               @ binario 0101 = puertas 2 y 4
    LDR R1, =0x8000
    STR R0, [R1]
    B check_players
correct_34:
    MOV R11, #2
    MOV R12, #3
    MOV R0, #0x3               @ binario 0011 = puertas 3 y 4
    LDR R1, =0x8000
    STR R0, [R1]
    B check_players
check_players:
    @ Verificar jugador 1
    CMP R8, R11
    BEQ skip_p1_damage
    CMP R8, R12
    BEQ skip_p1_damage
    LDR R1, =0x6000       @ Dirección vidas jugador 1
    LDR R6, [R1]
    SUB R6, R6, #1
    STR R6, [R1]
skip_p1_damage:
    @ Verificar jugador 2
    CMP R9, R11
    BEQ skip_p2_damage
    CMP R9, R12
    BEQ skip_p2_damage
    LDR R1, =0x7000       @ Dirección vidas jugador 2
    LDR R7, [R1]
    SUB R7, R7, #1
    STR R7, [R1]
skip_p2_damage:
    LDR R6, =0x6000       @ Comprobar vidas jugador 1
    LDR R0, [R6]
    CMP R0, #0
    BEQ end_game
    LDR R7, =0x7000       @ Comprobar vidas jugador 2
    LDR R0, [R7]
    CMP R0, #0
    BEQ end_game
wait_clear:
    LDR R3, =0x3000       @ Dirección del temporizador
    LDR R5, [R3]          @ Leer temporizador
    CMP R5, #0
    BNE wait_clear   
    B game_loop
end_game:
    B end_game            @ Juego terminado