module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

// State declaration to keep track of the previous, current, and next input states
reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end else begin
        // Shift the register and input the new data
        shift_reg <= {shift_reg[1:0], data_in};

        // Detecting a pulse
        // A pulse is detected when the register holds 010
        if (shift_reg == 3'b010) begin
            data_out <= 1'b1; // Pulse detected, set output high
        end else begin
            data_out <= 1'b0; // No pulse, set output low
        end
    end
end

endmodule