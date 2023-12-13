module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definition
    parameter IDLE = 2'b00;
    parameter PULSE_START = 2'b01;
    parameter PULSE_END = 2'b11;

    // State register
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset condition
            current_state <= IDLE;
        end else begin
            // Update state
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default assignment
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = PULSE_START;
                end
            end
            PULSE_START: begin
                if (data_in == 1'b0) begin
                    next_state = PULSE_END;
                end
            end
            PULSE_END: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset condition
            data_out <= 1'b0;
        end else begin
            // Generate output based on current state
            case (current_state)
                PULSE_START: data_out <= 1'b0;
                PULSE_END: data_out <= 1'b1;
                default: data_out <= 1'b0;
            endcase
        end
    end

endmodule