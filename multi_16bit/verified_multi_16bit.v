module verified_multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

reg [15:0] areg;    // Multiplicand a register.
reg [15:0] breg;    // Multiplier b register.
reg [31:0] yout_r;  // Product register.
reg done_r;
reg [4:0] i;        // Shift count register.


//------------------------------------------------
// Data bit control
always @(posedge clk or negedge rst_n)
    if (!rst_n) i <= 5'd0;
    else if (start && i < 5'd17) i <= i + 1'b1; 
    else if (!start) i <= 5'd0;

//------------------------------------------------
// Multiplication completion flag generation
always @(posedge clk or negedge rst_n)
    if (!rst_n) done_r <= 1'b0;
    else if (i == 5'd16) done_r <= 1'b1; // Multiplication completion flag
    else if (i == 5'd17) done_r <= 1'b0; // Flag reset

assign done = done_r;

//------------------------------------------------
// Dedicated register for shift and accumulate operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
        areg <= 16'h0000;
        breg <= 16'h0000;
        yout_r <= 32'h00000000;
    end
    else if (start) begin // Start operation
        if (i == 5'd0) begin // Store multiplicand and multiplier
            areg <= ain;
            breg <= bin;
        end
        else if (i > 5'd0 && i < 5'd17) begin
            if (areg[i-1]) 
            yout_r <= yout_r + ({16'h0000, breg} << (i-1)); // Accumulate and shift
        end
    end
end

assign yout = yout_r;

endmodule