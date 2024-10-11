module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        count <= 16'b0; 
    end else begin
        if (up_down) begin
            // Increment the counter if up_down is high
            if (count == 16'b1111_1111_1111_1111) begin
                count <= 16'b0; 
            end else begin
                count <= count + 1; 
            end
        end else begin
            // Decrement the counter if up_down is low
            if (count == 16'b0) begin
                count <= 16'b1111_1111_1111_1111; 
            end else begin
                count <= count - 1; 
            end
        end
    end
end

endmodule