module Sec_conx(
    input  logic clk, rst, rx, rx_e, tick,
    input  logic [3:0] recep,
    output logic rxReady,
    output logic [7:0] rxOut
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    logic [3:0] bit_index;
    logic [3:0] counter;
    logic [7:0] read_data;
    logic rx_sync;
    logic start_bit_detected;

    // Sincronizar rx_e para detección de flanco
    logic rx_e_prev;
    logic start_pulse;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            rx_e_prev <= 0;
            start_pulse <= 0;
        end else begin
            start_pulse <= (rx_e && !rx_e_prev && !rx); // flanco de bajada en rx
            rx_e_prev <= rx_e;
        end
    end

    // Estado siguiente
    always_ff @(posedge tick or negedge rst) begin
        if (!rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Transiciones de estado
    always_comb begin
        next_state = state;
        case (state)
            IDLE:  next_state = (start_pulse) ? START : IDLE;
            START: next_state = (counter == 4'd15) ? DATA : START;
            DATA:  next_state = (counter == 4'd15 && (bit_index + 1) == recep) ? STOP : DATA;
            STOP:  next_state = (counter == 4'd15) ? IDLE : STOP;
            default: next_state = IDLE;
        endcase
    end

    // Lectura por estados
    always_ff @(posedge tick or negedge rst) begin
        if (!rst) begin
            counter    <= 0;
            bit_index  <= 0;
            rxReady    <= 0;
            read_data  <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counter   <= 0;
                    bit_index <= 0;
                    rxReady   <= 0;
                end
                START: begin
                    if (counter == 4'd15)
                        counter <= 0;
                    else
                        counter <= counter + 1;
                end
                DATA: begin
                    if (counter == 4'd15) begin
                        read_data[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                STOP: begin
                    if (counter == 4'd15) begin
                        rxReady <= 1;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
            endcase
        end
    end

    // Salida
    always_ff @(posedge clk) begin
        rxOut <= read_data;
    end

endmodule