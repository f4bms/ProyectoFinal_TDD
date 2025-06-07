module Sec_conx (
    input  logic clk, rst, rx, tick, rxEn,
    input  logic [2:0] recep, 
    output logic [7:0] rxOut,
    output logic rxDone,
    output logic rxReady
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    logic [3:0] counter;
    logic [3:0] bit_index;
    logic [7:0] rx_data;

    // Máquina de estados
    always_ff @(posedge tick or negedge rst) begin
        if (!rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Transición de estados con rxEn como control
    always_comb begin
        next_state = state;
        case (state)
            IDLE:  next_state = (rxEn && !rx) ? START : IDLE;
            START: next_state = (counter == 4'd7) ? DATA  : START;
            DATA:  next_state = (counter == 4'd15 && (bit_index == recep)) ? STOP : DATA;
            STOP:  next_state = (counter == 4'd15) ? IDLE  : STOP;
            default: next_state = IDLE;
        endcase
    end

  
    always_ff @(posedge tick or negedge rst) begin
        if (!rst) begin
            counter   <= 0;
            bit_index <= 0;
            rxOut     <= 0;
            rx_data   <= 0;
            rxDone    <= 0;
            rxReady   <= 1;
        end else begin
            rxDone <= 0;

            case (state)
                IDLE: begin
                    counter   <= 0;
                    bit_index <= 0;
                    rxReady   <= rxEn;
                end
                START: begin
                    rxReady <= 0;
                    if (counter == 4'd7)
                        counter <= 0;
                    else
                        counter <= counter + 1;
                end
                DATA: begin
                    rxReady <= 0;
                    if (counter == 4'd15) begin
                        rx_data[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                STOP: begin
                    if (counter == 4'd15) begin
                        rxOut   <= rx_data;
                        rxDone  <= 1;
                        rxReady <= 1;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

endmodule

