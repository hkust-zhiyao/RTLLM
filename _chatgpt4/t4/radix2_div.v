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

// State definitions
localparam IDLE  = 2'b00,
           SUB   = 2'b01,
           SHIFT = 2'b10,
           DONE  = 2'b11;

// FSM and data registers
reg [1:0] current_state, next_state;
reg [DATAWIDTH-1:0] dividend_e, divisor_e, quotient_e, remainder_e;
reg [DATAWIDTH:0] count; // Count needs an extra bit to go up to DATAWIDTH

// State transition logic
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and data computation logic
always @(*) begin
    // Default assignments
    next_state = current_state;
    ready = 1'b0;
    vld_out = 1'b0;
    dividend_e = dividend_e;
    divisor_e = divisor_e << 1;
    quotient_e = quotient_e;
    remainder_e = remainder_e;

    case (current_state)
        IDLE: begin
            ready = 1'b1;
            if (en) begin
                dividend_e = dividend;
                divisor_e = divisor;
                quotient_e = 0;
                remainder_e = 0;
                count = DATAWIDTH;
                next_state = SUB;
            end
        end
        SUB: begin
            // Perform subtraction if the remainder is greater or equal to divisor
            if (remainder_e >= divisor_e) begin
                remainder_e = remainder_e - divisor_e;
                quotient_e = (quotient_e << 1) | 1'b1;
            end else begin
                quotient_e = quotient_e << 1;
            end
            next_state = SHIFT;
        end
        SHIFT: begin
            if (count == 0) begin
                next_state = DONE;
            end else begin
                remainder_e = remainder_e << 1;
                remainder_e[0] = dividend_e[DATAWIDTH-1];
                dividend_e = dividend_e << 1;
                count = count - 1'b1;
                next_state = SUB;
            end
        end
        DONE: begin
            quotient = quotient_e;
            remainder = remainder_e;
            vld_out = 1'b1;
            if (!en) begin
                next_state = IDLE;
            end
        end
    endcase
end

// Asynchronous reset logic
always @(negedge rstn) begin
    if (!rstn) begin
        quotient <= 0;
        remainder <= 0;
        dividend_e <= 0;
        divisor_e <= 0;
        quotient_e <= 0;
        remainder_e <= 0;
        count <= 0;
        ready <= 0;
        vld_out <= 0;
        current_state <= IDLE;
    end
end

endmodule