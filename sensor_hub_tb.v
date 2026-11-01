module sensor_hub_tb;

    reg clk, rst;
    reg select_sensor;
    reg sensor_valid;
    reg [7:0] sensor0_data;
    reg [7:0] sensor1_data;

    wire uart_tx_out;
    wire tx_busy_out;
    wire tx_done_out;
    wire fifo_full_out;
    wire fifo_empty_out;
    wire [2:0] fifo_count_out;

    sensor_hub_top uut (
        .clk(clk),
        .rst(rst),
        .select_sensor(select_sensor),
        .sensor_valid(sensor_valid),
        .sensor0_data(sensor0_data),
        .sensor1_data(sensor1_data),
        .uart_tx_out(uart_tx_out),
        .tx_busy_out(tx_busy_out),
        .tx_done_out(tx_done_out),
        .fifo_full_out(fifo_full_out),
        .fifo_empty_out(fifo_empty_out),
        .fifo_count_out(fifo_count_out)
    );

    always #5 clk = ~clk;

    task send_sensor;
        input sensor_select;
        input [7:0] expected_data;
        begin
            // Wait until the previous transaction has settled
            repeat (5) @(negedge clk);

            select_sensor = sensor_select;
            sensor_valid = 1;

            @(negedge clk);
            sensor_valid = 0;

            // Wait for actual UART completion
            wait (tx_done_out == 1'b1);

            $display(
                "PASS: Sensor %0d, expected data = %0d, UART transmission completed at time %0t",
                sensor_select, expected_data, $time
            );

            // Allow FSM to return to IDLE
            repeat (5) @(negedge clk);
        end
    endtask

task check_uart_frame;
    input [7:0] expected;
    integer i;
    reg [7:0] received;

    begin
        @(negedge uart_tx_out);

        // Middle of start bit
        #20;

        // Sample 8 data bits
        for (i = 0; i < 8; i = i + 1) begin
            #40;
            received[i] = uart_tx_out;
        end

        // Check stop bit
        #40;

        if (uart_tx_out === 1'b1 &&
            received === expected) begin

            $display(
                "UART DATA VERIFIED: Received=%0d",
                received
            );
        end
        else begin
            $display(
                "UART DATA ERROR: Expected=%0d Received=%0d Stop=%b",
                expected, received, uart_tx_out
            );
        end
    end
endtask

    initial begin
        $dumpfile("sensor_hub.vcd");
        $dumpvars(0, sensor_hub_tb);

        clk = 0;
        rst = 1;
        select_sensor = 0;
        sensor_valid = 0;

        sensor0_data = 25;
        sensor1_data = 80;

        repeat (2) @(negedge clk);
        rst = 0;

        // Test 1: Temperature sensor
        send_sensor(0, 25);

        // Test 2: Light sensor
        send_sensor(1, 80);

        $display("Both sensor transactions completed.");

        #20;
        $finish;
    end

    initial begin
        $monitor(
            "Time=%0t Select=%b Valid=%b FIFO_count=%d FIFO_empty=%b UART_TX=%b Busy=%b Done=%b",
            $time, select_sensor, sensor_valid,
            fifo_count_out, fifo_empty_out,
            uart_tx_out, tx_busy_out, tx_done_out
        );
    end

initial begin 
   check_uart_frame(8'd25);
   check_uart_frame(8'd80);
end

endmodule
