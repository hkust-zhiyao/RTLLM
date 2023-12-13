module radix2_div #(parameter DATAWIDTH = 8) (
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
    reg [DATAWIDTH-1:0] dividend_e, divisor_e;
    reg [DATAWIDTH-1:0] quotient_e, remainder_e;
    reg [DATAWIDTH:0] count;

    // Next state logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM, data registers, and output logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            dividend_e <= 0;
            divisor_e <= 0;
            quotient_e <= 0;
            remainder_e <= 0;
            count <= 0;
            ready <= 1;
            vld_out <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    ready <= 1;
                    vld_out <= 0;
                    if (en) begin
                        dividend_e <= dividend;
                        divisor_e <= divisor;
                        quotient_e <= 0;
                        remainder_e <= 0;
                        count <= DATAWIDTH; // Set counter for number of iterations
                        next_state <= SUB;
                        ready <= 0;
                    end
                end
                SUB: begin
                    // Subtraction stage
                    if (dividend_e >= divisor_e) begin
                        remainder_e <= dividend_e - divisor_e;
                        quotient_e <= (quotient_e << 1) | 1;
                    end else begin
                        remainder_e <= dividend_e;
                        quotient_e <= quotient_e << 1;
                    end
                    next_state <= SHIFT;
                end
                SHIFT: begin
                    // Shifting stage
                    if (count > 0) begin
                        dividend_e <= remainder_e << 1;
                        count <= count - 1;
                        next_state <= SUB;
                    end else begin
                        next_state <= DONE;
                    end
                end
                DONE: begin
                    // Completion stage
                    quotient <= quotient_e;
                    remainder <= remainder_e;
                    vld_out <= 1;
                    next_state <= IDLE;
                end
                default: begin
                    next_state <= IDLE;
                end
            endcase
        end
    end

endmodule