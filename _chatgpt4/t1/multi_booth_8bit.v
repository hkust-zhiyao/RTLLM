module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [7:0] multiplicand;
    reg [8:0] multiplier; // Extra bit for the Booth algorithm
    reg [3:0] ctr;       // Counter for iterations
    reg [1:0] booth_code;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize the multiplier module
            multiplicand <= 0;
            multiplier <= {1'b0, b};
            p <= 0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            // Check if the multiplication process is completed
            if (ctr < 8) begin
                booth_code <= {multiplier[1:0], 1'b0}; // Radix-4 Booth encoding
                
                case (booth_code)
                    3'b001, 3'b010: p <= p + (multiplicand << (2 * ctr)); // +A operation
                    3'b101, 3'b110: p <= p - (multiplicand << (2 * ctr)); // -A operation
                    // For 3'b000, 3'b011, 3'b100, and 3'b111, no operation is performed on p
                endcase

                // Prepare for the next iteration
                multiplier <= multiplier >> 2; // Radix-4 right shift
                ctr <= ctr + 1;
            end else if (ctr == 8) begin
                // Indicate that the multiplication process is completed
                rdy <= 1;
                ctr <= ctr + 1; // Increment ctr to stop the operation
            end
        end
    end

endmodule