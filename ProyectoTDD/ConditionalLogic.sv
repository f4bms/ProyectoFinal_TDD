module ConditionalLogic(
    input logic clk, reset,
    input logic [3:0] Cond,
    input logic [3:0] ALUFlags,
    input logic [1:0] FlagW,
    input logic PCS,
    input logic RegW,
    input logic NoWrite,
    input logic MemW,
    output logic PCSrc,
    output logic RegWrite,
    output logic MemWrite,
    output logic [1:0] F32
);

    logic [1:0] Flags32 = '{default:32'd0}, Flags10 = '{default:32'd0};
    logic [1:0] FlagWrite;

    logic CondEx;



    assign FlagWrite = FlagW & {2{CondEx}};
    assign F32 = Flags32;

    always_ff @ (posedge clk or posedge reset) begin
        if (reset) begin
            Flags32 <= 2'b00;
            Flags10 <= 2'b00;
        end else begin
            if (FlagWrite[1]) begin
                Flags32 <= ALUFlags[3:2]; // Guardar flags de 32 bits
            end
            if (FlagWrite[0]) begin
                Flags10 <= ALUFlags[1:0]; // Guardar flags de 10 bits
            end
        end
    end

    

    ConditionCheck condition_check (
        .flags({Flags32, Flags10}),
        .Cond(Cond),
        .CondEx(CondEx)
    );

    always_comb begin
        // Lógica combinacional para la lógica condicional
        PCSrc = PCS & CondEx; // Actualizar PC si se cumple la condición
        RegWrite = RegW & CondEx & ~NoWrite; // Habilitar escritura en registro si se cumple la condición y NoWrite es 0
        MemWrite = MemW & CondEx; // Habilitar escritura en memoria si se cumple la condición
    end

    


endmodule