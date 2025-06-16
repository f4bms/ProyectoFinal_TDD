`timescale 1ns / 1ps
// test_Proyecto2.sv
module test_Proyecto2;

    // Clock and reset
    logic clk;
    logic reset;
    logic [15:0][31:0] leds_registers;
    logic [31:0] instr; // Output for the instruction (PC)
    logic [31:0] PC_led; // Output for the PC (same as instr for this test)
    logic [31:0] ALUres; // Output for the ALU result
    logic [1:0] F32;

    // Instantiate the DUT
    Proyecto2 dut (
        .clk(clk),
        .reset(reset),
        .leds_registers(leds_registers), // Output for the LEDs of the registers
        .instr(instr), // Output for the instruction (PC)
        .PC_led(PC_led) // Output for the PC (same as instr for this test)
        , .ALUres(ALUres) // Output for the ALU result
        , .F32(F32)
    );

    // Clock generation for 50MHz (period = 20ns, half-period = 10ns)
    initial clk = 1;
    always #10 clk = ~clk; 

    // Test sequence
    initial begin
        

        // Wait for a few cycles
        repeat (20) @(posedge clk);


        // Finish simulation
        $finish;
    end

endmodule