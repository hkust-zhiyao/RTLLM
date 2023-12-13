module pulse_detect(
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    // State declaration for the Finite State Machine (FSM)
    typedef enum reg [1:0] {
        IDLE = 2'b00, // Waiting for pulse start
        PULSE_START = 2'b01, // Detected rising edge
        PULSE_END = 2'b10 // Detected falling edge
    } state_type;

    // Register to hold the current state
    reg [1:0] current_state = IDLE;
    reg [1:0] next_state = IDLE;

    // Sequential logic for state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state logic and output generation
    always @(*) begin
        case (current_state)
            IDLE: begin
                data_out = 1'b0;
                // Check for rising edge
                if (data_in == 1'b1) begin
                    next_state = PULSE_START;
                end else begin
                    next_state = IDLE;
                end
            end
            PULSE_START: begin
                // Check for falling edge
                if (data_in == 1'b0) begin
                    next_state = PULSE_END;
                end else begin
                    next_state = PULSE_START;
                end
            end
            PULSE_END: begin
                // Pulse detected, output goes high for one cycle
                data_out = 1'b1;
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
                data_out = 1'b0;
            end
        endcase
    end

endmodule