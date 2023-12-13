module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // Define state identifiers
    parameter [2:0] S0 = 3'b000, // Start state (or state after reset)
                     S1 = 3'b001, // After seeing '1'
                     S2 = 3'b010, // After seeing '10'
                     S3 = 3'b011, // After seeing '100'
                     S4 = 3'b100, // After seeing '1001'
                     S5 = 3'b101; // After seeing '10011'

    // State variable
    reg [2:0] current_state, next_state;

    // Sequential logic for state transitions
    always @(posedge CLK or posedge RST) begin
        if (RST)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Combinational logic for next state and MATCH output
    always @(*) begin
        // Default assignment
        MATCH = 0;
        next_state = current_state; // Stay in the current state by default

        case (current_state)
            S0: begin
                if (IN) next_state = S1;
            end
            S1: begin
                if (!IN) next_state = S2;
            end
            S2: begin
                if (!IN) next_state = S3;
                else next_state = S1;
            end
            S3: begin
                if (IN) next_state = S4;
                else next_state = S2;
            end
            S4: begin
                if (IN) begin
                    next_state = S5;
                    MATCH = 1; // MATCH output is set to '1' upon reaching S5
                end else begin
                    next_state = S2;
                end
            end
            S5: begin
                if (IN) next_state = S1;
                else next_state = S2;
            end
            default: next_state = S0;
        endcase
    end

endmodule