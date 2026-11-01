module uart_tx_tb;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire tx;
    wire tx_busy;
    wire tx_done;

    uart_tx #(
        .CLKS_PER_BIT(4)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    always #5 clk = ~clk;

    initial begin

        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tx_tb);

        clk = 0;
        rst = 1;
        tx_start = 0;
        data_in = 8'd25;

        #12;
        rst = 0;

        // Start transmission
        #8;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait until transmission finishes
        wait(tx_done == 1'b1);

        #20;
        $finish;

    end

    initial begin
        $monitor(
            "Time=%0t Data=%d TX=%b Busy=%b Done=%b",
            $time, data_in, tx, tx_busy, tx_done
        );
    end

endmodule

