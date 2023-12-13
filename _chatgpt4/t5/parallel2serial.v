module parallel2serial(
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // Internal registers
    reg [3:0] data_reg;
    reg [1:0] cnt; // 2-bit counter to handle 4 clock cycles for 4 bits

    // On every positive edge of the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Resetting all registers when rst_n is 0
            data_reg <= 4'b0000;
            cnt <= 2'b00;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // If counter is 3, indicating the last bit is being outputted, load new data
            if (cnt == 2'b11) begin
                data_reg <= d; // Load the parallel data
                cnt <= 2'b00; // Reset the counter
                valid_out <= 1'b1; // Set valid_out high as data is ready to be outputted
            end else begin
                cnt <= cnt + 1; // Increment the counter
                data_reg <= {data_reg[2:0], 1'b0}; // Shift left the data register
                valid_out <= (cnt == 2'b00) ? 1'b1 : 1'b0; // valid_out high only when cnt is 0
            end
            dout <= data_reg[3]; // Assign MSB of data_reg to dout
        end
    end

endmodule