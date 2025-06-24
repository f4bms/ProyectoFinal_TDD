module VideoRam(input logic clk,
                input logic reset,
                input logic [31:0] addr,  // Dirección de memoria
                input logic [31:0] WD, // Datos a escribir
                input logic WE, // Señal de escritura
                output logic [31:0] RD, // Datos leídos
                output logic [1:0] p1_lives,
                output logic [1:0] p2_lives,
                output logic [1:0] correct_door_1,
                output logic [1:0] correct_door_2
               );
               logic [31:0] memory [0:1023]; // Memoria de video

               // Lógica combinacional para lectura y salidas
               always_comb begin
                   RD = memory[addr];
                   p1_lives = memory[0][1:0];
                   p2_lives = memory[1][1:0];
                   correct_door_1 = memory[2][1:0];
                   correct_door_2 = memory[3][1:0];
               end

               // Escritura secuencial
               always_ff @(posedge clk or posedge reset) begin
                   if (reset) begin
                       memory[0] <= 32'h00000000; // Reset player 1 lives
                       memory[1] <= 32'h00000000; // Reset player 2 lives
                       memory[2] <= 32'h00000000; // Reset correct doors
                   end else begin
                       if (WE) begin
                           memory[addr] <= WD;
                       end
                   end
               end
                
endmodule