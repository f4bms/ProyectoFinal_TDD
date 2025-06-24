`timescale 1ns / 1ps
module tb_ProcesadorARMv4;

    // Declaración de señales
    logic clk, reset;
    logic [31:0] instruccion, PC, WriteDataMem, AddressDataMem, ReadData;
    logic WriteEnableMem;

    // Instanciar el procesador ARM
    ProcesadorARMv4 procesador (
        .clk(clk),
        .reset(reset),
        .Instruction(instruccion), // Instrucción de 32 bits
        .PC(PC), // Contador de Programa
        .WriteDataMem(WriteDataMem),
        .AddressDataMem(AddressDataMem), // Datos a escribir en memoria
        .WriteEnableMem(WriteEnableMem), // Habilitar escritura en memoria
        .ReadData(ReadData) // Datos leídos de memoria
    );

    
    // Inicializar la instrucción de prueba

    InstMemory inst_memory (
        .clk(clk),
        .reset(reset),
        .PC(PC), // Contador de Programa
        .Instruction(instruccion) // Instrucción de 32 bits
    );

    // Instanciar la memoria de datos

    logic [3:0] posJ1, posJ2; // Posiciones de los jugadores
    logic [1:0] pos_J1, pos_J2; // Posiciones de los jugadores para la memoria de datos
    logic time_up; // Señal de tiempo agotado

    logic [31:0] VGAAddr; // Dirección de memoria para lectura de VGA
    logic [31:0] DataVideo; // Datos de video leídos de memoria

    logic [1:0] p1_lives, p2_lives; // Vidas de los jugadores
    logic [31:0] correct_door_1, correct_door_2; // Puertas correctas

    DataMemory data_memory ( 
        .clk(clk),
        .reset(reset),
        .addr_A(AddressDataMem), // Dirección de memoria
        .addr_B(VGAAddr), // Dirección de memoria para lectura de VGA
        .WD(WriteDataMem), // Datos a escribir
        .WE(WriteEnableMem), // Señal de escritura
        .posJ1(posJ1), // Posición del jugador 1
        .posJ2(posJ2), // Posición del jugador 2
        .pos_J1(pos_J1), // Posición del jugador 1 para la memoria de datos
        .pos_J2(pos_J2), // Posición del jugador 2 para la memoria de datos
        .p1_lives(p1_lives), // Vidas del jugador 1
        .p2_lives(p2_lives), // Vidas del jugador 2
        .correct_door_1(correct_door_1), // Puerta correcta del jugador 1
        .correct_door_2(correct_door_2), // Puerta correcta del jugador 2
        .time_up(time_up), // No se usa en este test, pero se puede conectar si es necesario
        .RD(ReadData) // Datos leídos

    );

    initial begin
        // Inicializar las posiciones de los jugadores
        posJ1 = 4'b1000;
        posJ2 = 4'b1000;
        time_up = 0; // Inicializar la señal de tiempo agotado
    end

    initial clk = 0; // Inicializar el reloj

    always #20 clk = ~clk; // Generar un reloj de 25 MHz (periodo de 40 ns)

    // Generar señales de reloj y reset
    initial begin
        clk = 0;
        reset = 1;
        #5 reset = 0;

        repeat (10) @(posedge clk);

        time_up = 1; // Simular que el tiempo se ha agotado
        posJ1 = 4'b0001; // Cambiar la posición del jugador 1
        posJ2 = 4'b0010; // Cambiar la posición del jugador 2

        repeat (50) @(posedge clk); // Esperar 90 ciclos de reloj
        time_up = 0; // Reiniciar la señal de tiempo agotado

        repeat (15) @(posedge clk); // Esperar 100 ciclos de reloj

        time_up = 1; // Simular que el tiempo se ha agotado nuevamente

        repeat (50) @(posedge clk); // Esperar 50 ciclos de reloj

        // Terminar la simulación
        $finish;


    end
    

endmodule