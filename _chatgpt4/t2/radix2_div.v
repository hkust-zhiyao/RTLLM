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

    // State declaration for the FSM
    localparam IDLE = 2'b00,
               SUB = 2'b01,
               SHIFT = 2'b10,
               DONE = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Data registers
    reg [DATAWIDTH-1:0] dividend_e, divisor_e;
    reg [DATAWIDTH-1:0] quotient_e, remainder_e;
    reg [DATAWIDTH:0] count; // Extra bit for counting up to DATAWIDTH times

    // FSM and calculation logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            current_state <= IDLE;
            quotient_e <= 0;
            remainder_e <= 0;
            dividend_e <= 0;
            divisor_e <= 0;
            count <= 0;
            ready <= 1'b1;
            vld_out <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (en) begin
                        dividend_e <= dividend;
                        divisor_e <= divisor << (DATAWIDTH-1); // Align divisor to the leftmost part
                        quotient_e <= 0;
                        remainder_e <= 0;
                        count <= DATAWIDTH; // Initialize the count
                        ready <= 1'b0;
                        current_state <= SUB;
                    end
                end
                SUB: begin
                    // Subtract the divisor from the dividend and check if it's non-negative
                    if (dividend_e >= divisor_e) begin
                        dividend_e <= dividend_e - divisor_e;
                        quotient_e <= (quotient_e << 1) | 1'b1; // Set the current quotient bit to 1
                    end else begin
                        quotient_e <= quotient_e << 1; // Set the current quotient bit to 0
                    end
                    current_state <= SHIFT;
                end
                SHIFT: begin
                    if (count == 0) begin
                        current_state <= DONE;
                    end else begin
                        divisor_e <= divisor_e >> 1; // Shift the divisor right
                        count <= count - 1; // Decrement the counter
                        current_state <= SUB;
                    end
                end
                DONE: begin
                    quotient <= quotient_e;
                    remainder <= dividend_e;
                    ready <= 1'b1;
                    vld_out <= 1'b1;
                    current_state <= IDLE;
                end
                default: current_state <= IDLE;
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        case (current_state)
            IDLE: begin
                ready = 1'b1;
                vld_out = 1'b0;
            end
            DONE: begin
                ready = 1'b0;
                vld_out = 1'b1;
            end
            default: begin
                ready = 1'b0;
                vld_out = 1'b0;
            end
        endcase
    end

endmodule