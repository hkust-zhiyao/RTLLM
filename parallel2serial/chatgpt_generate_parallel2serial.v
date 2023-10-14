module chatgpt_generate_parallel2serial(
    input clk,
    input rst,
    input [3:0] d,
    output valid_in,
    output dout
);

// Internal registers to hold the state
reg [2:0] count;
reg [3:0] shift_reg;
reg valid_out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'b0;
        shift_reg <= 4'b0;
        valid_out <= 1'b0;
    end
    else begin
        if (count == 3'b0) begin
            shift_reg <= d;
            valid_out <= 1'b1;
        end
        else begin
            shift_reg <= {shift_reg[2:0], d};
            valid_out <= 1'b0;
        end

        count <= count + 1;
    end
end

assign valid_in = valid_out;
assign dout = shift_reg[0];

endmodule