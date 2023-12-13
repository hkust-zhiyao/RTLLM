module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [7:0] multiplicand;
    reg [8:0] multiplier; // Extra bit for sign extension
    reg [3:0] ctr; // 4-bit counter since we are processing 2 bits at a time

    // Initialize the registers on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= 0;
            multiplier <= {1'b0, b}; // Sign extend the multiplier
            p <= 0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            // Check if the multiplication process is complete
            if (ctr < 4) begin
                case (multiplier[1:0]) // Radix-4 Booth Encoding
                    2'b01: p <= p + (multiplicand << (ctr * 2));
                    2'b10: p <= p - (multiplicand << (ctr * 2));
                    default: p <= p; // No operation for 00 and 11
                endcase

                // Prepare for the next iteration
                multiplier <= multiplier >> 2; // Consume the next 2 bits
                ctr <= ctr + 1; // Increment the counter
            end else begin
                rdy <= 1; // Indicate that the multiplication is done
            end
        end
    end

    // Sign extension handling for negative numbers
    always @(posedge clk) begin
        if (ctr == 0 && !rdy) begin
            multiplicand <= a[7] ? (~a + 1'b1) : a; // If negative, take 2's complement
        end
    end

endmodule