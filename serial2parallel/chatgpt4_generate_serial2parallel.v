module chatgpt4_generate_serial2parallel(
    input clk,
    input rst_n,
    input valid_a,
    input data_a,
    output reg ready_a,
    output reg valid_b,
    output reg [5:0] data_b
);

    reg [2:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ready_a <= 1'b0;
            valid_b <= 1'b0;
            data_b <= 6'b0;
            count <= 3'b0;
        end else if (valid_a && ready_a) begin
            data_b <= {data_a, data_b[5:1]};
            count <= count + 1;

            if (count == 5) begin
                valid_b <= 1'b1;
                ready_a <= 1'b0;
            end else begin
                valid_b <= 1'b0;
                ready_a <= 1'b1;
            end
        end else if (valid_b) begin
            valid_b <= 1'b0;
            ready_a <= 1'b1;
            count <= 3'b0;
        end else begin
            ready_a <= 1'b1;
        end
    end

endmodule