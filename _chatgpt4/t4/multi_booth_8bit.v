module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal signals
    reg [7:0] multiplicand;  // Extended multiplicand
    reg [8:0] multiplier;    // Extended multiplier and an extra bit for the algorithm
    reg [4:0] ctr;           // 5-bit counter (for 8-bit multiplication, we need 8*2 steps)
    reg [16:0] product;      // Extended product to hold intermediate values (1 extra bit)
    reg neg;

    // Booth multiplier control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the multiplier
            multiplicand <= 0;
            multiplier <= {1'b0, b};
            product <= 0;
            ctr <= 0;
            rdy <= 0;
            neg <= 0;
        end else begin
            if (ctr < 9) begin
                // Radix-2 Booth's algorithm operations
                case ({multiplier[1], multiplier[0]})
                    2'b01: product[16:1] <= product[16:1] + {a, 1'b0};
                    2'b10: product[16:1] <= product[16:1] - {a, 1'b0};
                    default: ; // No operation for 00 and 11
                endcase
                
                // Prepare for the next iteration
                product <= product >> 1; // Arithmetic shift right
                product[16] <= product[15]; // Sign extension
                multiplier <= multiplier >> 1; // Logical shift right
                ctr <= ctr + 1;
            end else if (ctr == 9) begin
                // Final step: adjust for sign extension if needed
                if (neg) begin
                    product <= product - {a, 8'h00};
                end
                p <= product[16:1]; // Assign the final product
                rdy <= 1; // Indicate completion
                ctr <= ctr + 1; // Increment counter to stop the process
            end
        end
    end

endmodule