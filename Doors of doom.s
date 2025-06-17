main:
    MOV R0, #0

    LDR R1, =0x1000       @ Reset entrada jugador 1
    STR R0, [R1]

    LDR R1, =0x2000       @ Reset entrada jugador 2
    STR R0, [R1]

    LDR R1, =0x4000       @ Reset número aleatorio
    STR R0, [R1]

    MOV R0, #3
    LDR R1, =0x6000       @ Vidas jugador 1
    STR R0, [R1]

    LDR R1, =0x7000       @ Vidas jugador 2
    STR R0, [R1]

game_loop:
    LDR R4, =0x4000       @ Dirección del número aleatorio
    LDR R3, =0x3000       @ Dirección del temporizador

    LDR R5, [R3]          @ Leer temporizador
    CMP R5, #0
    BNE game_loop         @ Esperar a que llegue a 0

    LDR R1, =0x1000       @ Entrada jugador 1
    LDR R2, =0x2000       @ Entrada jugador 2

    LDR R8, [R1]          @ Elección jugador 1
    LDR R9, [R2]          @ Elección jugador 2
    LDR R10, [R4]         @ Número aleatorio (1 a 6)

    @ Obtener las dos puertas correctas según el número aleatorio
    CMP R10, #1
    BEQ correct_12
    CMP R10, #2
    BEQ correct_13
    CMP R10, #3
    BEQ correct_14
    CMP R10, #4
    BEQ correct_23
    CMP R10, #5
    BEQ correct_24
    CMP R10, #6
    BEQ correct_34

correct_12:
    MOV R11, #1
    MOV R12, #2
    B check_players

correct_13:
    MOV R11, #1
    MOV R12, #3
    B check_players

correct_14:
    MOV R11, #1
    MOV R12, #4
    B check_players

correct_23:
    MOV R11, #2
    MOV R12, #3
    B check_players

correct_24:
    MOV R11, #2
    MOV R12, #4
    B check_players

correct_34:
    MOV R11, #3
    MOV R12, #4
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
    CMP R5, #9
    BNE wait_clear   

    B game_loop

end_game:
    B end_game            @ Juego terminado
