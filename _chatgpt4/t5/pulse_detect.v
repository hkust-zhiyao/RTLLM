module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // Define states for the FSM
    parameter IDLE = 2'b00,
              DETECT_RISE = 2'b01,
              DETECT_FALL = 2'b10;

    // State register
    reg [1:0] state;
    reg [1:0] next_state;

    // Sequential block for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Combinational block for next state logic and output assignment
    always @(*) begin
        // Default assignments
        next_state = state;
        data_out = 1'b0;

        case (state)
            IDLE: begin
                // If a rising edge is detected, move to DETECT_RISE state
                if (data_in == 1'b1) begin
                    next_state = DETECT_RISE;
                end
            end
            DETECT_RISE: begin
                // If data_in is 0 after being 1, we have detected a falling edge
                if (data_in == 1'b0) begin
                    next_state = DETECT_FALL;
                end
            end
            DETECT_FALL: begin
                // Detected a pulse, so output should be high
                data_out = 1'b1;
                // Look for the next pulse
                next_state = IDLE;
            end
            default: begin
                // In case of an undefined state, go back to IDLE
                next_state = IDLE;
            end
        endcase
    end

endmodule