module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State definitions (one-hot encoding for clarity)
    localparam [2:0] IDLE = 3'b001,
                     PULSE_START = 3'b010,
                     PULSE_END = 3'b100;

    // State register
    reg [2:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset (active low)
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state; // State transition
        end
    end

    // Combinatorial logic for next state and output
    always @(*) begin
        // Default assignments
        next_state = current_state; 
        data_out = 1'b0;

        case (current_state)
            IDLE: begin
                // Waiting for pulse start
                if (data_in == 1'b1) begin
                    next_state = PULSE_START;
                end
            end
            PULSE_START: begin
                // Pulse started, waiting for pulse end
                if (data_in == 1'b0) begin
                    next_state = PULSE_END;
                end
            end
            PULSE_END: begin
                // End of pulse detected, generate output pulse
                data_out = 1'b1;
                // Wait for next pulse
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                end else if (data_in == 1'b1) begin
                    // Handle case where pulse remains high and goes back to low
                    next_state = PULSE_START;
                end
            end
            default: begin
                // Should not reach here, but return to a known state
                next_state = IDLE;
            end
        endcase
    end

endmodule