module Proyecto2( // No es proyecto 1?
    input logic clk, reset
);

logic [31:0] Instruction; // Instrucción de 32 bits
logic [31:0] PC; // Contador de Programa

// Memoria de instrucciones
InstMemory inst_mem (
    .clk(clk),
    .reset(reset),
    .PC(PC),
    .Instruction(Instruction)
);

// Memoria de datos
logic [31:0] WriteDataMem; // Datos a escribir en el registro
logic [31:0] AddressDataMem; // Dirección de memoria para escritura
logic WriteEnableMem; // Habilitar escritura en memoria
logic [31:0] ReadData; // Datos leídos de memoria

DataMemory data_mem (
    .clk(clk),
    .reset(reset),
    .A(AddressDataMem), 
    .WD(WriteDataMem), // Placeholder para los datos a escribir
    .WE(WriteEnableMem), // No se escribe en este momento
    .RD(ReadData) // No se usa en este momento
);

// Procesador ARMv4
ProcesadorARMv4 proc (
    .clk(clk),
    .reset(reset),
    .Instruction(Instruction), 
    .PC(PC), // Salida del PC
    .WriteDataMem(WriteDataMem),
    .AddressDataMem(AddressDataMem),
    .WriteEnableMem(WriteEnableMem), // No se escribe en memoria en este momento
    .ReadData(ReadData)
);


endmodule