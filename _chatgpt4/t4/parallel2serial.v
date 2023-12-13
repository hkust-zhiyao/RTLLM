module parallel2serial(
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

// Internal registers
reg [2:0] cnt; // 3-bit counter to track the bit position
reg [3:0] data; // Register to hold the current state of data being serialized

// Sequential logic for counter and data register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset
        cnt <= 3'd0;
        data <= 4'd0;
        valid_out <= 1'b0;
    end else begin
        // Check if we are on the last bit
        if (cnt == 3'd3) begin
            // Load new data and reset counter
            data <= d;
            cnt <= 3'd0;
            valid_out <= 1'b1; // Output is valid on the loading of new data
        end else begin
            // Shift data and increment counter
            data <= {data[2:0], 1'b0};
            cnt <= cnt + 3'd1;
            valid_out <= (cnt == 3'd0) ? 1'b1 : 1'b0; // Output is valid only if the counter was 0 before incrementing
        end
    end
end

// Combinational logic for serial output
always @(*) begin
    // dout is assigned the MSB of the data register
    dout = data[3];
end

endmodule