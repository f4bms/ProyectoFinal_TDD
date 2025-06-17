module Proyecto2( // No es proyecto 1?
    input logic clk, reset
    ,output logic [15:0][31:0] leds_registers  // Salida para los LEDs de los registros
    , output logic [31:0] instr // Contador de Programa
    , output logic [31:0] PC_led // Contador de Programa
    , output logic [31:0] ALUres
    ,output logic [1:0] F32
    , output logic [31:0] mem
);
logic [31:0] Instruction; // Instrucción de 32 bits
logic [31:0] PC; // Contador de Programa

assign instr = Instruction; // Asignar el PC a la salida instr
assign PC_led = PC; // Asignar el PC a la salida PC_led

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

// Memoria de datos simple: un solo registro de 32 bits
logic [31:0] single_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        single_reg <= 32'd0;
    end else if (WriteEnableMem) begin
        single_reg <= WriteDataMem;
    end
end

assign ReadData = single_reg;
assign mem = single_reg;


// Procesador ARMv4
ProcesadorARMv4 proc (
    .clk(clk),
    .reset(reset),
    .Instruction(Instruction), 
    .PC(PC), // Salida del PC
    .WriteDataMem(WriteDataMem),
    .AddressDataMem(AddressDataMem),
    .WriteEnableMem(WriteEnableMem), // No se escribe en memoria en este momento
    .ReadData(ReadData),
    .leds_registers(leds_registers) // Salida para los LEDs de los registros
    , .ALUres(ALUres) // Salida para el resultado de la ALU
    , .F32(F32)
);


endmodule