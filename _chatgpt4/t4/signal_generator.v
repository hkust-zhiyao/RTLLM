module signal_generator(
    input wire clk,
    input wire rst_n,
    output reg [4:0] wave
);

    // Internal state register to control the direction of the count
    reg state;

    // Define the state values for clarity
    localparam STATE_UP = 1'b0;
    localparam STATE_DOWN = 1'b1;

    // Reset and waveform generation are handled on the rising edge of the clock
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Resetting the module
            wave <= 5'b00000;
            state <= STATE_UP; // Start by incrementing
        end else begin
            case (state)
                STATE_UP: begin
                    // Check if wave reached the max value
                    if (wave == 5'b11111) begin
                        state <= STATE_DOWN; // Change state to down
                        wave <= wave - 1'b1;
                    end else begin
                        wave <= wave + 1'b1; // Increment wave
                    end
                end
                STATE_DOWN: begin
                    // Check if wave reached the min value
                    if (wave == 5'b00000) begin
                        state <= STATE_UP; // Change state to up
                        wave <= wave + 1'b1;
                    end else begin
                        wave <= wave - 1'b1; // Decrement wave
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