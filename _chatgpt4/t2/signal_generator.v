module signal_generator (
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    // State declaration
    reg state;

    // State definitions
    localparam STATE_UP = 1'b0;
    localparam STATE_DOWN = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            wave <= 5'b00000; // Initialize wave to 0
            state <= STATE_UP; // Start with incrementing state
        end else begin
            case (state)
                STATE_UP: begin
                    // Increment wave until it reaches 31
                    if (wave == 31) begin
                        state <= STATE_DOWN; // Change state to decrement
                    end else begin
                        wave <= wave + 1;
                    end
                end
                STATE_DOWN: begin
                    // Decrement wave until it reaches 0
                    if (wave == 0) begin
                        state <= STATE_UP; // Change state to increment
                    end else begin
                        wave <= wave - 1;
                    end
                end
                default: begin
                    // In case of an undefined state, reset to known state
                    state <= STATE_UP;
                    wave <= 5'b00000;
                end
            endcase
        end
    end

endmodule