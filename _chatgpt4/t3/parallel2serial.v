module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Internal counter to keep track of bit position
    reg [1:0] cnt; // 2-bit counter for 4 clock cycles

    // Register to hold the current state of the data
    reg [3:0] data;

    // On every clock edge...
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the state and outputs
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            data <= 4'b0;
        end else begin
            // Check if it is time to load new data and reset the counter
            if (cnt == 2'b11) begin
                data <= d;         // Load the new data
                cnt <= 2'b0;      // Reset the counter
                valid_out <= 1'b1; // Output is valid
                dout <= d[3];      // Start with MSB
            end else begin
                cnt <= cnt + 2'b1; // Increment the counter
                valid_out <= (cnt == 2'b0) ? 1'b1 : 1'b0; // Valid only after loading new data or when counter is 0
                data <= {data[2:0], 1'b0}; // Shift left the data
                dout <= data[3]; // Output the leftmost bit
            end
        end
    end
endmodule