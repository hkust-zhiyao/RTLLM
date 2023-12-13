module signal_generator(
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    // Define state register
    reg state;

    // Define states for readability
    localparam STATE_UP = 1'b0;
    localparam STATE_DOWN = 1'b1;

    // Waveform generation always block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            wave <= 5'd0;
            state <= STATE_UP;
        end else begin
            case (state)
                STATE_UP: begin
                    // Increment the wave
                    if (wave == 5'd31) begin
                        // Transition to STATE_DOWN if maximum is reached
                        state <= STATE_DOWN;
                        wave <= wave - 5'd1;
                    end else begin
                        // Continue incrementing
                        wave <= wave + 5'd1;
                    end
                end
                STATE_DOWN: begin
                    // Decrement the wave
                    if (wave == 5'd0) begin
                        // Transition to STATE_UP if minimum is reached
                        state <= STATE_UP;
                        wave <= wave + 5'd1;
                    end else begin
                        // Continue decrementing
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    // In case of an undefined state, reset to known state
                    state <= STATE_UP;
                    wave <= 5'd0;
                end
            endcase
        end
    end

endmodule