module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output wire valid_out,
    output wire [9:0] data_out
);

    reg [9:0] accumulator;
    reg [2:0] counter;
    reg valid_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            accumulator <= 10'b0;
            counter <= 3'b0;
            valid_out_reg <= 1'b0;
        end else begin
            if (valid_in) begin
                accumulator <= accumulator + data_in;
                counter <= counter + 1'b1;
            end
            
            if (counter == 3'b11) begin
                valid_out_reg <= 1'b1;
                counter <= 3'b0;
            end else begin
                valid_out_reg <= 1'b0;
            end
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out = accumulator;

endmodule