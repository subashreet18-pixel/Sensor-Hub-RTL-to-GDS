module fsm_controller_tb;

    reg clk, rst;
    reg sensor_valid;
    reg fifo_full, fifo_empty;
    reg tx_busy;

    wire wr_en, rd_en, tx_start;

    fsm_controller uut (
        .clk(clk),
        .rst(rst),
        .sensor_valid(sensor_valid),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .tx_busy(tx_busy),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .tx_start(tx_start)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("fsm.vcd");
        $dumpvars(0, fsm_controller_tb);

        clk = 0;
        rst = 1;
        sensor_valid = 0;
        fifo_full = 0;
        fifo_empty = 1;
        tx_busy = 0;

        #12 rst = 0;

        // New sensor data arrives
        #3 sensor_valid = 1;
        #10 sensor_valid = 0;

        // Model FIFO receiving one item
        #2 fifo_empty = 0;

        // Model UART starting transmission
        #28 tx_busy = 1;

        // Model UART finishing transmission
        #20 tx_busy = 0;
        fifo_empty = 1;

        #30;

        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t sensor_valid=%b fifo_empty=%b tx_busy=%b wr_en=%b rd_en=%b tx_start=%b",
            $time, sensor_valid, fifo_empty, tx_busy,
            wr_en, rd_en, tx_start
        );
    end

endmodule
