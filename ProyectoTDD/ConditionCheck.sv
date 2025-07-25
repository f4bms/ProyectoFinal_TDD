module ConditionCheck(
    input logic [3:0] flags , // Flags de estado (N, Z, C, V)
    input logic [3:0] Cond,  // Condición a evaluar
    output logic CondEx // Señal que indica si la condición se cumple
);

    always_comb begin
        // Inicializar condition_met a 0
        CondEx = 1'b0;

        // Evaluar la condición según los flags y el código de condición
        case (Cond)

            4'b0000: CondEx = flags[2]; // EQ (Equal)
            4'b0001: CondEx = ~flags[2]; // NE (Not Equal)
            4'b0010: CondEx = flags[1]; // CS/HS (Carry Set / High Set)
            4'b0011: CondEx = ~flags[1]; // CC/LO (Carry Clear / Low)
            4'b0100: CondEx = flags[3]; // MI (Minus)
            4'b0101: CondEx = ~flags[3]; // PL (Plus)
            4'b0110: CondEx = flags[0]; // VS (Overflow Set)
            4'b0111: CondEx = ~flags[0]; // VC (Overflow Clear)
            4'b1000: CondEx = ~flags[2] & flags[1]; // HI (Higher)
            4'b1001: CondEx = flags[2] | ~flags[1]; // LS (Lower or Same)
            4'b1010: CondEx = ~(flags[3] ^ flags[0]); // GE (Greater or Equal)
            4'b1011: CondEx = flags[3] ^ flags[0]; // LT (Less Than)
            4'b1100: CondEx = ~flags[2] & ~(flags[3] ^ flags[0]);// GT (Greater Than)
            4'b1101: CondEx = flags[2] | (flags[3] ^ flags[0]); // LE (Less Than or Equal)
            4'b1110: CondEx = 1'b1; // AL (Always, condición siempre cumplida)
            default: CondEx = 1'b0; // Por defecto, condición no cumplida

        endcase
    end
    
endmodule
