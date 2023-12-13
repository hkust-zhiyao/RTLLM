module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave // 5-bit output for wave
);

    // State register declaration
    reg state;
    
    // Define states for readability
    localparam STATE_INCREASING = 1'b0;
    localparam STATE_DECREASING = 1'b1;

    // Waveform generation and state management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            wave <= 5'd0;
            state <= STATE_INCREASING;
        end else begin
            case (state)
                STATE_INCREASING: begin
                    if (wave == 5'd31) begin
                        // Transition to decreasing state
                        state <= STATE_DECREASING;
                        wave <= wave - 5'd1;
                    end else begin
                        // Increment wave
                        wave <= wave + 5'd1;
                    end
                end
                STATE_DECREASING: begin
                    if (wave == 5'd0) begin
                        // Transition to increasing state
                        state <= STATE_INCREASING;
                        wave <= wave + 5'd1;
                    end else begin
                        // Decrement wave
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    // Just in case we get into an unknown state, reset to a known state
                    state <= STATE_INCREASING;
                    wave <= 5'd0;
                end
            endcase
        end
    end

endmodule