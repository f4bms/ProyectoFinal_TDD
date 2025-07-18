module ProcesadorARMv4(
    input logic clk, reset,
    input logic [31:0] Instruction, // Instrucción de 32 bits
    output logic [31:0] PC, // Contador de Programa
    output logic [31:0] WriteDataMem, AddressDataMem, // Datos a escribir en memoria
    output logic WriteEnableMem, // Habilitar escritura en memoria
    input logic [31:0] ReadData

); 

    // Señales internas y de control
    logic [31:0] PC_Next; // Siguiente valor del PC
    logic PCSrc;
    logic MemtoReg;
    logic [1:0] ALUControl;
    logic ALUSrcA, ALUSrcB; // Señal para seleccionar entre registro y inmediato
    logic [1:0] ImmSrc;
    logic RegWrite;
    logic [1:0] RegSrc; // Ajustar el tamaño si es necesario
    logic [3:0] ALUFlags; // Flags de la ALU (N, Z, C, V)
    logic [31:0] PCPlus4; // PC + 4
    logic [31:0] WriteDataReg; // Datos a escribir en el registro
    logic [31:0] PCPlus8;
    logic [3:0] RA1, RA2; // Salidas de lectura de los registros
    logic [31:0] RD1, RD2; // Datos leídos de los registros
    logic [31:0] ALUResult; // Resultado de la ALU
    logic [31:0] ALUInputA, ALUInputB; // Entrada B de la ALU
    logic [31:0] ExtImm; // Inmediato extendido


    // Unidad de control
    ControlUnit ctrl_unit (
        .clk(clk),
        .reset(reset),
        .instruction(Instruction[31:12]), // Asumiendo que la instrucción es de 32 bits y se usan los bits 31 a 12
        .ALUFlags(ALUFlags), // Conectar los flags de la ALU
        .PCSrc(PCSrc),
        .MemtoReg(MemtoReg),
        .MemWrite(WriteEnableMem),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .RegSrc(RegSrc)
    );

    // Contador de Programa (PC)
    

    always_comb begin
        PCPlus4 = PC + 4; // Sumar 4 al PC actual
        PCPlus8 = PCPlus4 + 4; // PC + 8
    end

    mux2to1 #(.m(32)) mux_PC (
        .a(PCPlus4), // Siguiente PC normal
        .b(WriteDataReg), // PC relativo
        .sel(PCSrc), // Conectar la señal de selección adecuada
        .y(PC_Next) // Siguiente valor del PC
    );

    // Inicialización del PC para simulación
    

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 32'h00000000;
        end else begin
            PC <= PC_Next;
        end
    end

    mux2to1 #(.m(4)) mux_regA1 (
        .a(Instruction[19:16]), // Rn
        .b(4'd15), // R15
        .sel(RegSrc[0]), // Conectar la señal de selección adecuada
        .y(RA1) // Salida A1 para el registro
    );



    mux2to1 #(.m(4)) mux_regA2 (
        .a(Instruction[3:0]), // Rd
        .b(Instruction[15:12]), // Rm
        .sel(RegSrc[1]), // Conectar la señal de selección adecuada
        .y(RA2) // Salida A2 para el registro
    );


    RegisterFile reg_file (
        .clk(clk),
        .reset(reset),
        .A1(RA1),
        .A2(RA2),
        .A3(Instruction[15:12]), // Rd
        .WD3(WriteDataReg), // Datos a escribir en el registro
        .R15(PCPlus8), // Usualmente R15 es el PC
        .WE(RegWrite), // Señal de escritura
        .RD1(RD1), // Dato leído del registro A1
        .RD2(RD2) // Dato leído del registro A2
    );

    // ALU

    extend ext_unit (
        .Instruction(Instruction[23:0]), // Asumiendo que la instrucción es de 24 bits
        .ImmSrc(ImmSrc), // Conectar la señal de selección de extensión
        .ExtImm(ExtImm) // Salida de la extensión
    );

    
    // Seleccionar la entrada B de la ALU
    mux2to1 #(.m(32)) mux_ALUInputA (
        .a('0), 
        .b(RD1), // Inmediato de la instrucción
        .sel(ALUSrcA), // Conectar la señal de selección adecuada
        .y(ALUInputA) // Salida B para la ALU
    );

    // Seleccionar la entrada B de la ALU
    mux2to1 #(.m(32)) mux_ALUInputB (
        .a(RD2), // Dato leído del registro A2
        .b(ExtImm), // Inmediato de la instrucción
        .sel(ALUSrcB), // Conectar la señal de selección adecuada
        .y(ALUInputB) // Salida B para la ALU
    );

    

    alu #(.W(32)) alu_unit (
        .A(ALUInputA), // Entrada A de la ALU
        .B(ALUInputB),
        .op(ALUControl), // Conectar la señal de control de la ALU
        .op_result(ALUResult),
        .N(ALUFlags[3]), // N flag
        .Z(ALUFlags[2]), // Z flag
        .C(ALUFlags[1]), // C flag
        .V(ALUFlags[0])  // V flag
    );

    // Memoria de datos
    assign WriteDataMem = RD2; // Datos a escribir en memoria tomando de RD2
    assign AddressDataMem = ALUResult; // Dirección de memoria tomada del resultado de la ALU

    // Mux para seleccionar los datos a escribir en el registro

    

    mux2to1 #(.m(32)) mux_WriteData (
        .a(ALUResult), // Resultado de la ALU
        .b(ReadData), // Datos leídos de memoria
        .sel(MemtoReg), // Conectar la señal de control para seleccionar entre ALU y memoria
        .y(WriteDataReg) // Salida de datos a escribir en el registro
    );
    


endmodule