module readMUX #(
    parameter WIDTH = 32
)(
    input  logic [1:0] rdsel,   
    input  logic [WIDTH-1:0] rdata0,
    input  logic [WIDTH-1:0] rdata1,
    input  logic [WIDTH-1:0] rdata2, 
    input  logic [WIDTH-1:0] rdata3, 
    output logic [WIDTH-1:0] readData 
);

    always_comb
        unique case (rdsel)
            2'b00 : readData = rdata0;
            2'b01 : readData = rdata1;
            2'b10 : readData = rdata2;
            2'b11 : readData = rdata3;
            default: readData = '0;
        endcase
endmodule