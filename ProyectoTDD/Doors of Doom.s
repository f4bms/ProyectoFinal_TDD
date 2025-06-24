.global _start
_start:
    MOV R0, #3              @ Inicializar el juego con 3 vidas
    LDR R1, =0x6000         @ Dirección de las vidas del jugador 1
    STR R0, [R1]            @ Guardar 3 vidas para jugador 1
    LDR R1, =0x7000         @ Dirección de las vidas del jugador 2
    STR R0, [R1]            @ Guardar 3 vidas para jugador 2

game_loop:
    LDR R3, =0x3000         @ Dirección del temporizador
    LDR R5, [R3]            @ Leer valor del temporizador
    CMP R5, #1              @ ¿El temporizador llegó a 1?
    BNE game_loop           @ Si no, seguir esperando
    LDR R4, =0x4000         @ Dirección del número aleatorio
    LDR R10, [R4]           @ Leer número aleatorio
    CMP R10, #0
    BEQ correct_01          @ Saltar según el número aleatorio
    CMP R10, #1
    BEQ correct_02
    CMP R10, #2
    BEQ correct_03
    CMP R10, #3
    BEQ correct_12
    CMP R10, #4
    BEQ correct_13
    CMP R10, #5
    BEQ correct_23

correct_01:
    MOV R11, #0             @ Puerta correcta 0
    MOV R12, #1             @ Puerta correcta 1
    LDR R1, =0x8000         @ Dirección para mostrar puerta 1
    STR R11, [R1]
    LDR R1, =0x9000         @ Dirección para mostrar puerta 2
    STR R12, [R1]
    B check_players         @ Verificar jugadores

correct_02:
    MOV R11, #0             @ Puerta correcta 0
    MOV R12, #2             @ Puerta correcta 2
    LDR R1, =0x8000
    STR R11, [R1]
    LDR R1, =0x9000
    STR R12, [R1]
    B check_players

correct_03:
    MOV R11, #0             @ Puerta correcta 0
    MOV R12, #3             @ Puerta correcta 3
    LDR R1, =0x8000
    STR R11, [R1]
    LDR R1, =0x9000
    STR R12, [R1]
    B check_players

correct_12:
    MOV R11, #1             @ Puerta correcta 1
    MOV R12, #2             @ Puerta correcta 2
    LDR R1, =0x8000
    STR R11, [R1]
    LDR R1, =0x9000
    STR R12, [R1]
    B check_players

correct_13:
    MOV R11, #1             @ Puerta correcta 1
    MOV R12, #3             @ Puerta correcta 3
    LDR R1, =0x8000
    STR R11, [R1]
    LDR R1, =0x9000
    STR R12, [R1]
    B check_players

correct_23:
    MOV R11, #2             @ Puerta correcta 2
    MOV R12, #3             @ Puerta correcta 3
    LDR R1, =0x8000
    STR R11, [R1]
    LDR R1, =0x9000
    STR R12, [R1]
    B check_players

check_players:
    LDR R0, =0x1000         @ Dirección de entrada jugador 1
    LDR R8, [R0]            @ Leer elección jugador 1
    CMP R8, R11             @ ¿Eligió puerta correcta 1?
    BEQ skip_p1_damage
    CMP R8, R12             @ ¿Eligió puerta correcta 2?
    BEQ skip_p1_damage 
    LDR R1, =0x6000         @ Dirección vidas jugador 1
    LDR R6, [R1]            @ Leer vidas actuales
    SUB R6, R6, #1          @ Restar 1 vida
    STR R6, [R1]            @ Guardar vidas actualizadas
skip_p1_damage:
    LDR R0, =0x2000         @ Dirección de entrada jugador 2
    LDR R9, [R0]            @ Leer elección jugador 2
    CMP R9, R11             @ ¿Eligió puerta correcta 1?
    BEQ skip_p2_damage
    CMP R9, R12             @ ¿Eligió puerta correcta 2?
    BEQ skip_p2_damage
    LDR R1, =0x7000         @ Dirección vidas jugador 2
    LDR R7, [R1]            @ Leer vidas actuales
    SUB R7, R7, #1          @ Restar 1 vida
    STR R7, [R1]            @ Guardar vidas actualizadas
skip_p2_damage:
    LDR R6, =0x6000         @ Dirección vidas jugador 1
    LDR R0, [R6]            @ Leer vidas jugador 1
    CMP R0, #0              @ ¿Sin vidas?
    BEQ end_game            @ Fin del juego si es 0
    LDR R7, =0x7000         @ Dirección vidas jugador 2
    LDR R0, [R7]            @ Leer vidas jugador 2
    CMP R0, #0              @ ¿Sin vidas?
    BEQ end_game            @ Fin del juego si es 0
wait_clear:
    LDR R3, =0x3000         @ Dirección del temporizador
    LDR R5, [R3]            @ Leer temporizador
    CMP R5, #0              @ ¿Temporizador en 0?
    BNE wait_clear          @ Esperar a que llegue a 0
    B game_loop             @ Siguiente ronda
end_game:
    B end_game              @ Bucle infinito al terminar el juego
