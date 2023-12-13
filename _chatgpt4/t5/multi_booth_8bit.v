module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [7:0] multiplicand, multiplier;
    reg [4:0] count; // 4 bits to count up to 8 iterations
    reg [1:0] booth_code;
    reg [16:0] product; // 1 extra bit for sign extension

    wire [1:0] next_booth_code = {multiplier[1], multiplier[0]};
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            product <= 0;
            multiplicand <= a;
            multiplier <= b;
            count <= 0;
            rdy <= 0;
        end else begin
            case (next_booth_code)
                2'b01: product = product + (multiplicand << count);
                2'b10: product = product - (multiplicand << count);
                default: product = product; // 2'b00 or 2'b11 means no operation
            endcase
            
            // Prepare for the next iteration
            count = count + 1;
            multiplier = multiplier >> 2; // Shift by 2 for Radix-4 Booth

            // Check if multiplication is complete
            if (count == 4'b1000) begin // After 8 iterations
                rdy <= 1;
                p <= product[15:0]; // Assign the lower 16 bits to output
            end
        end
    end

endmodule