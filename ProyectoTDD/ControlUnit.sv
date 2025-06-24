module ControlUnit(
    input logic clk, reset,
    input logic [31:12] instruction,
    input logic [3:0] ALUFlags,
    output logic PCSrc,
    output logic MemtoReg,
    output logic MemWrite,
    output logic [1:0] ALUControl,
    output logic ALUSrcA, ALUSrcB,
    output logic [1:0] ImmSrc,
    output logic RegWrite,
    output logic [1:0] RegSrc
);

    logic [5:0] Funct;
    logic [3:0] Cond, Rd;
    logic [1:0] OpCode;

    assign Cond = instruction[31:28];
    assign OpCode = instruction[27:26];
    assign Funct = instruction[25:20];
    assign Rd = instruction[15:12];

    logic [1:0] FlagW;
    logic PCS, RegW, MemW, NoWrite;

    Decoder decoder (
        .Rd(Rd),
        .OpCode(OpCode),
        .Funct(Funct),
        .PCS(PCS),
        .RegW(RegW),
        .MemW(MemW),
        .MemtoReg(MemtoReg),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegSrc(RegSrc),
        .NoWrite(NoWrite),
        .ALUControl(ALUControl), // Asignar los bits más significativos
        .FlagW(FlagW)
    );

    ConditionalLogic conditional_logic (
        .clk(clk),
        .reset(reset),
        .Cond(Cond),
        .ALUFlags(ALUFlags),
        .FlagW(FlagW),
        .PCS(PCS),
        .RegW(RegW),
        .NoWrite(NoWrite),
        .MemW(MemW),
        .PCSrc(PCSrc),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite)
    );

    




   

endmodule