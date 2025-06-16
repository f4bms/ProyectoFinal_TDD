module Decoder(
    input logic [3:0] Rd,
    input logic [1:0] OpCode,
    input logic [5:0] Funct,
    output logic PCS,
    output logic RegW,
    output logic MemW,
    output logic MemtoReg,
    output logic ALUSrcA, ALUSrcB,
    output logic [1:0] ImmSrc,
    output logic [1:0] RegSrc,
    output logic NoWrite,
    output logic [1:0] ALUControl,
    output logic [1:0] FlagW
);

    logic Branch, ALUOp;

    MainDecoder main_decoder (
        .OpCode(OpCode),
        .Funct5(Funct[5]),
        .Funct0(Funct[0]),
        .Branch(Branch),
        .MemtoReg(MemtoReg),
        .MemW(MemW),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegW(RegW),
        .RegSrc(RegSrc),
        .ALUOp(ALUOp)
    );

    PCLogic pc_logic (
        .Rd(Rd),
        .Branch(Branch),
        .RegW(RegW),
        .PCS(PCS)
    );

    ALUDecoder alu_decoder (
        .ALUOp(ALUOp),
        .Funct(Funct[4:0]),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .FlagW(FlagW),
        .NoWrite(NoWrite) // NoWrite se usa para indicar que no se escribirá en la ALU
    );


endmodule