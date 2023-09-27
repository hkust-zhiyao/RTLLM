module chatgpt_generate_accu (
    input                 clk,      // Clock input
    input                 rst_n,    // Asynchronous active low reset
    input  [7:0]          data_in,  // Input 8-bit data
    input                 valid_a,  // Input valid signal from upstream
    output reg            ready_a,  // Output ready signal to upstream
    input                 ready_b,  // Input ready signal from downstream
    output reg            valid_b,  // Output valid signal to downstream
    output reg [9:0]      data_out  // Output 10-bit accumulated data
);

// Internal states and counters
reg [1:0]  count;         // Counter to track received data count
reg [9:0]  acc_data;      // Accumulated data

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 2'b0;
        acc_data <= 10'b0;
        ready_a <= 1'b0;
        valid_b <= 1'b0;
    end else begin
        // Data accumulation process
        if (valid_a && ready_b) begin
            acc_data <= acc_data + {2'b0, data_in}; // Accumulate 8-bit data
            count <= count + 1;
        end

        // Output ready control
        if (count == 2'b11)   // If 4 input data have been received
            ready_a <= 1'b1;  // Assert ready signal to upstream
        else
            ready_a <= 1'b0;  // De-assert ready signal to upstream

        // Output valid control
        if (count == 2'b11) begin
            valid_b <= 1'b1;     // Assert valid signal to downstream
            data_out <= acc_data; // Provide the accumulated result as output
        end else begin
            valid_b <= 1'b0;      // De-assert valid signal to downstream
            data_out <= 10'b0;    // Output is zero when not accumulating data
        end

        // Reset counter and accumulated data when 4 input data are accumulated
        if (count == 2'b11 && ready_b) begin
            count <= 2'b0;
            acc_data <= 10'b0;
        end else if (valid_a && ready_b) begin
            count <= count + 1; // Increment counter on each received data
        end
    end
end

endmodule
