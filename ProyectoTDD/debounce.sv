module debounce (
    input  logic clk,
    input  logic btn_in,
    output logic btn_out
);

    logic [15:0] count;
    logic btn_sync_0, btn_sync_1, btn_stable;

    // Sincronizar a clk
    always_ff @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

    // Contador para detectar estabilidad
    always_ff @(posedge clk) begin
        if (btn_sync_1 == btn_stable) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 16'hFFFF)
                btn_stable <= btn_sync_1;
        end
    end

    assign btn_out = btn_stable;

endmodule