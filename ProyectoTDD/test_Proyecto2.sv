`timescale 1ns / 1ps
// test_Proyecto2.sv
module test_Proyecto2;

    logic reset;
    logic CLOCK_50;
    logic [8:0] SW;
    logic [1:0] botones1;
    logic [1:0] botones2;
    logic [6:0] HEX0;
    logic [6:0] HEX1;
    logic [9:0] LEDR;
    logic VGA_CLK;
    logic VGA_HS;
    logic VGA_VS;
    logic [7:0] VGA_R;
    logic [7:0] VGA_G;
    logic [7:0] VGA_B;
    logic VGA_BLANK_N;
    logic [15:0][31:0] leds_registers;
    logic [31:0] instrucciones; // No se usa en el test, pero se puede conectar si es necesario

    // Instancia del módulo Proyecto2
    Proyecto2 dut (
        .reset(reset),
        .CLOCK_50(CLOCK_50),
        .SW(SW),
        .botones1(botones1),
        .botones2(botones2),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .LEDR(LEDR),
        .VGA_CLK(VGA_CLK),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_BLANK_N(VGA_BLANK_N),
        .leds_registers(leds_registers),
        .instrucciones(instrucciones) // No se usa en el test, pero se puede conectar si es necesario
    );

    // Clock generation for 50MHz (period = 20ns, half-period = 10ns)
    initial CLOCK_50 = 1;
    always #10 CLOCK_50 = ~CLOCK_50;

    // Test sequence
    initial begin
        reset = 1; // Start with reset
        SW = 9'b0;
        botones1 = 2'b01;
        botones2 = 2'b00;
        #12
        reset = 0; // Release reset after a short time

        

        // Wait for a few cycles
        repeat (200) @(posedge CLOCK_50);


        // Finish simulation
        $finish;
    end

endmodule