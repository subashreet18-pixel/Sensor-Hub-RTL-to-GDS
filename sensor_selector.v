module sensor_selector (
    input clk,
    input rst,
    input select_sensor,
    input valid_in,

    input [7:0] sensor0_data,
    input [7:0] sensor1_data,

    output reg [7:0] data_out,
    output reg valid_out
);

always @(posedge clk) begin

    if (rst) begin
        data_out <= 8'b0;
        valid_out <= 1'b0;
    end

    else begin
        valid_out <= valid_in;

        if (valid_in) begin
            if (select_sensor == 1'b0)
                data_out <= sensor0_data;
            else
                data_out <= sensor1_data;
        end
    end

end

endmodule
