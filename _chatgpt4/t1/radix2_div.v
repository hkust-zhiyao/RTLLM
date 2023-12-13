module radix2_div #(
    parameter DATAWIDTH = 8
)(
    input clk,
    input rstn,
    input en,
    input [DATAWIDTH-1:0] dividend,
    input [DATAWIDTH-1:0] divisor,
    output reg ready,
    output reg [DATAWIDTH-1:0] quotient,
    output reg [DATAWIDTH-1:0] remainder,
    output reg vld_out
);

    // FSM states
    localparam IDLE = 2'b00,
               SUB = 2'b01,
               SHIFT = 2'b10,
               DONE = 2'b11;
    
    // Registers for FSM, counters and extended operands
    reg [1:0] current_state, next_state;
    reg [DATAWIDTH:0] dividend_e, divisor_e, remainder_e;
    reg [DATAWIDTH-1:0] quotient_e;
    reg [DATAWIDTH-1:0] count;

    // FSM state transition and data computation
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient_e <= 0;
            remainder_e <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            count <= 0;
            ready <= 1;
            vld_out <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (en) begin
                        current_state <= SUB;
                        dividend_e <= {1'b0, dividend};
                        divisor_e <= {1'b0, divisor};
                        quotient_e <= 0;
                        remainder_e <= 0;
                        count <= DATAWIDTH;
                        ready <= 0;
                        vld_out <= 0;
                    end
                end
                SUB: begin
                    if (dividend_e >= divisor_e) begin
                        remainder_e <= dividend_e - divisor_e;
                        quotient_e[0] <= 1;
                    end else begin
                        remainder_e <= dividend_e;
                        quotient_e[0] <= 0;
                    end
                    current_state <= SHIFT;
                end
                SHIFT: begin
                    if (count > 0) begin
                        count <= count - 1;
                        quotient_e <= {quotient_e[DATAWIDTH-2:0], 1'b0};
                        dividend_e <= {remainder_e[DATAWIDTH-2:0], dividend_e[0], 1'b0};
                        current_state <= SUB;
                    end else begin
                        current_state <= DONE;
                    end
                end
                DONE: begin
                    quotient <= quotient_e;
                    remainder <= remainder_e[DATAWIDTH-1:0];
                    ready <= 1;
                    vld_out <= 1;
                    if (!en) current_state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        case (current_state)
            IDLE: begin
                ready = 1'b1;
            end
            DONE: begin
                vld_out = 1'b1;
            end
            default: begin
                ready = 1'b0;
                vld_out = 1'b0;
            end
        endcase
    end

endmodule