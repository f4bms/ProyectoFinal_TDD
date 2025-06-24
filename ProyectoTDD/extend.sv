module extend(
    input  logic [23:0] Instruction,
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ExtImm
);

    logic [7:0] imm8;
    logic [3:0] rot;
    logic [31:0] imm_base;
    logic [31:0] imm32;

    always_comb begin
        imm8 = 8'b0;
        rot = 4'b0;
        imm_base = 32'b0;
        imm32 = 32'b0;
        ExtImm = 32'b0;

        case (ImmSrc)
            2'b00: begin
                imm8 = Instruction[7:0];
                rot  = Instruction[11:8];
                imm_base = {24'b0, imm8};

                if (rot == 0)
                    imm32 = imm_base;
                else
                    imm32 = (imm_base >> (rot * 2)) | (imm_base << (32 - (rot * 2)));

                ExtImm = imm32;
            end

            2'b01: ExtImm = {20'b0, Instruction[11:0]}; // para STR/LDR
            2'b10: ExtImm = {{6{Instruction[23]}}, Instruction[23:0], 2'b00}; // branch
            default: ExtImm = 32'b0;
        endcase
    end
endmodule
