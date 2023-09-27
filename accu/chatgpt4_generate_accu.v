module chatgpt4_generate_accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_a,
    input ready_b,
    output wire ready_a,
    output reg valid_b,
    output reg [9:0] data_out
);

reg [7:0] data_buffer [0:3];  // Buffer to store 4 8bit data
reg [1:0] counter;            // Counter for received data
reg [9:0] accum;              // Accumulator for data
reg state;                    // State for FSM

// FSM states
parameter IDLE = 1'b0, ACCUMULATE = 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        accum <= 10'b0;
        state <= IDLE;
        valid_b <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (valid_a && ready_b) begin
                    data_buffer[counter] <= data_in;
                    counter <= counter + 1;
                    if (counter == 2'b11) begin
                        accum <= accum + data_in;
                        data_out <= accum;
                        valid_b <= 1'b1;
                        state <= ACCUMULATE;
                    end else begin
                        accum <= accum + data_in;
                    end
                end
            end
            ACCUMULATE: begin
                if (ready_b) begin
                    counter <= 2'b00;
                    accum <= 10'b0;
                    state <= IDLE;
                    valid_b <= 1'b0;
                end
            end
        endcase
    end
end

// Output the ready signal when the module is not accumulating
assign ready_a = (state == IDLE);

endmodule