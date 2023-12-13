module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // State declaration
    typedef enum logic [2:0] {
        S0, // Initial state, waiting for '1'
        S1, // '1' detected, waiting for '0'
        S2, // '10' detected, waiting for another '0'
        S3, // '100' detected, waiting for '1'
        S4, // '1001' detected, waiting for '1' again for a match
        S5  // Match state, will go back to S0 or S3
    } state_t;

    // Current state and next state variables
    state_t current_state, next_state;

    // State transition and output logic
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
            MATCH <= (next_state == S5); // MATCH is high in S5
        end
    end

    // Next state logic based on current state and input
    always @(*) begin
        case (current_state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S3 : S2;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S0;
            default: next_state = S0;
        endcase
    end

endmodule