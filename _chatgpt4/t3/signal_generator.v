module signal_generator (
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave // 5-bit signal for the waveform
);

// State declaration
reg state; // Use a 1-bit signal to store the state, 0 for incrementing, 1 for decrementing

// Waveform generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset: clear the state and wave registers
        state <= 0;
        wave <= 5'b00000;
    end else begin
        case (state)
            // State 0: Increment wave until it reaches 31
            0: begin
                if (wave == 5'b11111) begin
                    state <= 1; // Transition to state 1 to start decrementing
                end else begin
                    wave <= wave + 1;
                end
            end
            
            // State 1: Decrement wave until it reaches 0
            1: begin
                if (wave == 5'b00000) begin
                    state <= 0; // Transition back to state 0 to start incrementing
                end else begin
                    wave <= wave - 1;
                end
            end
            
            // Handle undefined states (should never occur with a well-defined 1-bit state)
            default: begin
                state <= 0;
                wave <= 5'b00000;
            end
        endcase
    end
end

endmodule