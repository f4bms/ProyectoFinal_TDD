module ControlUnit(
    input logic clk, reset,
    input logic [31:12] instruction,
    input logic [3:0] flags,
    output logic PCSrc,
    output logic MemtoReg,
    output logic MemWrite,
    output logic [3:0] ALUControl, // Se decidió usar 4 bits para ALUControl
    output logic ALUSrc,
    output logic ImmSrc,
    output logic RegWrite,
    output logic [1:0] RegSrc
);


   

endmodule