module fsm_controller (
    input clk,
    input rst,
    input sensor_valid,
    input fifo_full,
    input fifo_empty,
    input tx_done,

    output reg wr_en,
    output reg rd_en,
    output reg tx_start
);

    localparam IDLE     = 3'b000,
               WRITE    = 3'b001,
               CHECK    = 3'b010,
               READ     = 3'b011,
               START_TX = 3'b100,
               WAIT_TX  = 3'b101;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;

        case (state)

            IDLE:
                if (sensor_valid && !fifo_full)
                    next_state = WRITE;

            WRITE:
                next_state = CHECK;

            CHECK:
                if (!fifo_empty)
                    next_state = READ;
                else
                    next_state = IDLE;

            READ:
                next_state = START_TX;

            START_TX:
                next_state = WAIT_TX;

            WAIT_TX:
                if (tx_done)
                    next_state = CHECK;

            default:
                next_state = IDLE;

        endcase
    end

    always @(*) begin
        wr_en = 0;
        rd_en = 0;
        tx_start = 0;

        case (state)

            WRITE:    wr_en = 1;
            READ:     rd_en = 1;
            START_TX: tx_start = 1;

        endcase
    end

endmodule
