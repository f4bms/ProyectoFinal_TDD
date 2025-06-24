module readMUX #(
    parameter WIDTH = 32
)(
    input  logic [2:0] rdsel,   
    input  logic [WIDTH-1:0] rdata0,
    input  logic [WIDTH-1:0] rdata1,
    input  logic [WIDTH-1:0] rdata2, 
    input  logic [WIDTH-1:0] rdata3,
    input  logic [WIDTH-1:0] rdata4,
    output logic [WIDTH-1:0] readData 
);

    always_comb
        unique case (rdsel)
            3'b000 : readData = rdata0;
            3'b001 : readData = rdata1;
            3'b010 : readData = rdata2;
            3'b011 : readData = rdata3;
            3'b100 : readData = rdata4;
            default: readData = '0;
        endcase
endmodule