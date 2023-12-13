`timescale 1ns / 1ps

module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State declaration using an enum for readability
    typedef enum logic [2:0] {
        S0, // Initial state, looking for '1'
        S1, // Got '1', looking for the first '0'
        S2, // Got '10', looking for the second '0'
        S3, // Got '100', looking for '1'
        S4  // Got '1001', looking for the second '1'
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition logic (Mealy machine)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic based on current state and input
    always @(*) begin
        // Default output
        MATCH = 1'b0;
        case (current_state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S3 : S2;
            S3: next_state = IN ? S1 : S4;
            S4: begin
                next_state = IN ? S1 : S2;
                MATCH = IN; // Only assert MATCH in the final state when IN is '1'
            end
            default: next_state = S0;
        endcase
    end

endmodule