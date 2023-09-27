module chatgpt4_generate_fsm (
    input CLK,
    input RST,
    input IN,
    output reg MATCH
);

    // Define state encoding
    parameter [3:0] S0 = 4'b0000,
                     S1 = 4'b0001,
                     S2 = 4'b0010,
                     S3 = 4'b0011,
                     S4 = 4'b0100,
                     S5 = 4'b0101;

    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state; // By default, stay in the current state
        case(state)
            S0: if(IN) next_state = S1;
            S1: if(!IN) next_state = S2;
                else next_state = S1;
            S2: if(IN) next_state = S3;
            S3: if(IN) next_state = S4;
            S4: if(!IN) next_state = S5;
                else next_state = S1;
            S5: next_state = S0;
        endcase
    end

    // State register
    always @(posedge CLK or negedge RST) begin
        if(!RST) state <= S0;
        else state <= next_state;
    end

    // Output logic
    always @(*) begin
        if(state == S5) MATCH = 1'b1;
        else MATCH = 1'b0;
    end

endmodule