module fsm(
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // Define the states
    typedef enum logic [2:0] {
        S0, // initial state, looking for '1'
        S1, // got '1', looking for '0'
        S2, // got '10', looking for another '0'
        S3, // got '100', looking for '1'
        S4  // got '1001', looking for final '1'
    } state_t;

    // State register
    state_t state, next_state;

    // State transition logic (Mealy FSM)
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default assignment for MATCH
        MATCH = 1'b0;
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S3 : S2;
            S3: next_state = IN ? S1 : S4;
            S4: begin
                next_state = IN ? S1 : S2;
                MATCH = IN; // MATCH will be high if IN is '1' in this state
            end
            default: next_state = S0;
        endcase
    end

endmodule