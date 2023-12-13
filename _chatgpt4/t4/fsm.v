module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // State declaration using an enumerated type for better readability
    typedef enum logic [2:0] {
        S0,    // Initial state, looking for '1'
        S1,    // Found '1', looking for first '0'
        S2,    // Found first '0', looking for second '0'
        S3,    // Found second '0', looking for '1'
        S4     // Found '1', looking for last '1' to match sequence
    } state_t;

    // State register
    state_t state, next_state;

    // Sequential logic for state register
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Combinatorial logic for next state and MATCH output
    always @(*) begin
        // Default assignment
        next_state = state;
        MATCH = 1'b0;

        case (state)
            S0: begin
                if (IN) next_state = S1;
            end
            S1: begin
                if (!IN) next_state = S2;
            end
            S2: begin
                if (!IN) next_state = S3;
                else next_state = S1; // Loop back if '1' is seen
            end
            S3: begin
                if (IN) next_state = S4;
                else next_state = S2; // Stay if '0' is seen
            end
            S4: begin
                if (IN) begin
                    MATCH = 1'b1; // Match found
                    next_state = S1; // Prepare for potential next match
                end else begin
                    next_state = S2; // No match, look for second '0'
                end
            end
            default: next_state = S0; // Default case
        endcase
    end

endmodule