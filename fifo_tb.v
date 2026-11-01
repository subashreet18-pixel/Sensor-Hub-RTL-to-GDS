module fifo_tb;

    reg clk, rst;
    reg wr_en, rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full, empty;
    wire [2:0] count;

    fifo uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .count(count)
    );

    always #5 clk = ~clk;

    task write_data(input [7:0] value);
    begin
        @(negedge clk);
        data_in = value;
        wr_en = 1;

        @(negedge clk);
        wr_en = 0;
    end
    endtask

    task read_data;
    begin
        @(negedge clk);
        rd_en = 1;

        @(negedge clk);
        rd_en = 0;
        $display("Read Data = %d", data_out);
    end
    endtask

    initial begin

        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #12;
        rst = 0;

        // Write four values
        write_data(25);
        write_data(80);
        write_data(45);
        write_data(60);

        // Read four values
        read_data();
        read_data();
        read_data();
        read_data();

        #10;
        $finish;

    end

endmodule
