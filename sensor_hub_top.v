module sensor_hub_top (
    input clk,
    input rst,

    input select_sensor,
    input sensor_valid,
    input [7:0] sensor0_data,
    input [7:0] sensor1_data,

    output uart_tx_out,
    output tx_busy_out,
    output tx_done_out,

    output fifo_full_out,
    output fifo_empty_out,
    output [2:0] fifo_count_out
);

    wire [7:0] selected_data;
    wire selected_valid;

    wire [7:0] fifo_data_out;

    wire wr_en;
    wire rd_en;
    wire tx_start;

    // Sensor Selector
    sensor_selector u_sensor (
        .clk(clk),
        .rst(rst),
        .select_sensor(select_sensor),
        .valid_in(sensor_valid),
        .sensor0_data(sensor0_data),
        .sensor1_data(sensor1_data),
        .data_out(selected_data),
        .valid_out(selected_valid)
    );

    // FIFO Buffer
    fifo u_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(selected_data),
        .data_out(fifo_data_out),
        .full(fifo_full_out),
        .empty(fifo_empty_out),
        .count(fifo_count_out)
    );

    // FSM Controller
    fsm_controller u_fsm (
        .clk(clk),
        .rst(rst),
        .sensor_valid(selected_valid),
        .fifo_full(fifo_full_out),
        .fifo_empty(fifo_empty_out),
        .tx_done(tx_done_out),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .tx_start(tx_start)
    );

    // UART Transmitter
    uart_tx #(
        .CLKS_PER_BIT(4)
    ) u_uart (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(fifo_data_out),
        .tx(uart_tx_out),
        .tx_busy(tx_busy_out),
        .tx_done(tx_done_out)
    );

endmodule

