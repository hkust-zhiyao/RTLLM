module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [31:0] product;
    reg [4:0] count;
    reg [15:0] multiplicand, multiplier;
    reg multiply_started;

    // Control logic for starting the multiplication
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiply_started <= 1'b0;
            count <= 5'b0;
            done <= 1'b0;
        end else if (start && !multiply_started) begin
            multiply_started <= 1'b1;
            multiplicand <= ain;
            multiplier <= bin;
            product <= 32'b0;
            count <= 5'b0;
            done <= 1'b0;
        end else if (multiply_started) begin
            if (count < 16) begin
                // Shift and accumulate
                if (multiplier[0]) begin
                    product <= product + (multiplicand << count);
                end
                multiplier <= multiplier >> 1;
                count <= count + 1;
            end else begin
                // Finish the multiplication
                multiply_started <= 1'b0;
                done <= 1'b1;
            end
        end else if (done) begin
            done <= 1'b0; // Clear the done flag once multiplication is complete
        end
    end

    // Assign the product to the output
    always @(posedge clk) begin
        if (done) begin
            yout <= product; // Output the final product
        end
    end

endmodule