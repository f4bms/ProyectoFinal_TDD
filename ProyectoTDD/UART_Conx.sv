module UART_Conx (
//la idea entonces es poner un switch para el enable e ir cambiandolo cuando quiera que me reciba el dato o no
//otra es poner algo que cuando el rx out sea 0 no haga nada y si es 1 haga algo y si es 2 haga otra cosa

    input  logic clk, rst, uart_rx, rxEn,
    input  logic [2:0]  recep,
    input  logic [15:0] BaudRate,

    output logic rxReady, rxDone, tick,
    output logic [7:0] rxOut
);

    logic Tick;


    BaudRate baud_gen(
        .clk(clk),
        .rst_n(rst),
        .tick(Tick),
        .baudRate(16'd325)
    );

		 Sec_conx urx (
		 .clk(clk),
		 .rst(rst),
		 .rx(uart_rx),
		 .tick(Tick),
		 .rxEn(rxEn),   
		 .recep(recep),
		 .rxReady(rxReady),
		 .rxOut(rxOut),
		 .rxDone(rxDone)
	);

	 assign tick = Tick;

endmodule