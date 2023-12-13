module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input wire clk,
    input wire rstn,
    input wire en,
    input wire [DATAWIDTH-1:0] dividend,
    input wire [DATAWIDTH-1:0] divisor,
    output reg ready,
    output reg [DATAWIDTH-1:0] quotient,
    output reg [DATAWIDTH-1:0] remainder,
    output reg vld_out
);

    // State encoding
    localparam IDLE  = 2'b00,
               SUB   = 2'b01,
               SHIFT = 2'b10,
               DONE  = 2'b11;

    // Registers for state machine
    reg [1:0] current_state, next_state;

    // Extended registers for computation
    reg [DATAWIDTH-1:0] dividend_e, divisor_e;
    reg [DATAWIDTH-1:0] quotient_e, remainder_e;
    reg [DATAWIDTH-1:0] count;

    // State machine logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // State transition and output logic
    always @(*) begin
        // Default assignments
        ready = 1'b0;
        vld_out = 1'b0;
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (en) begin
                    next_state = SUB;
                    quotient_e = 0;
                    dividend_e = dividend;
                    divisor_e = divisor << (DATAWIDTH - 1);
                    count = DATAWIDTH;
                end else begin
                    ready = 1'b1;
                end
            end
            SUB: begin
                // Perform subtraction if possible
                if (dividend_e >= divisor_e) begin
                    dividend_e = dividend_e - divisor_e;
                    quotient_e = (quotient_e << 1) | 1'b1;
                end else begin
                    quotient_e = (quotient_e << 1);
                end
                next_state = SHIFT;
            end
            SHIFT: begin
                if (count > 0) begin
                    divisor_e = divisor_e >> 1; // Shift right the divisor
                    count = count - 1;
                    next_state = SUB; // Go back to SUB to attempt another subtraction
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                quotient = quotient_e;
                remainder = dividend_e;
                vld_out = 1'b1;
                next_state = IDLE; // Return to IDLE after completion
            end
        endcase
    end

    // Asynchronous reset logic
    always @(negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            quotient_e <= 0;
            remainder_e <= 0;
            ready <= 1'b1;
            vld_out <= 1'b0;
        end
    end

endmodule