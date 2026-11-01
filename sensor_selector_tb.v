module sensor_selector_tb;

reg clk;
reg rst;
reg select_sensor;
reg valid_in;

reg [7:0] sensor0_data;
reg [7:0] sensor1_data;

wire [7:0] data_out;
wire valid_out;

sensor_selector uut (
    .clk(clk),
    .rst(rst),
    .select_sensor(select_sensor),
    .valid_in(valid_in),
    .sensor0_data(sensor0_data),
    .sensor1_data(sensor1_data),
    .data_out(data_out),
    .valid_out(valid_out)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("sensor.vcd");
    $dumpvars(0, sensor_selector_tb);

    clk = 0;
    rst = 1;
    valid_in = 0;
    select_sensor = 0;

    sensor0_data = 8'd25;
    sensor1_data = 8'd80;

    #10 rst = 0;

    // Read temperature sensor
    select_sensor = 0;
    valid_in = 1;
    #10;

    // Read light sensor
    select_sensor = 1;
    #10;

    valid_in = 0;
    #10;

    $finish;

end

initial begin
    $monitor("Time=%0t Sensor=%d Data=%d Valid=%b",
             $time, select_sensor, data_out, valid_out);
end

endmodule
