`timescale 1ns / 1ps

module verified_booth4_mul #(
    parameter WIDTH_M = 8,
    parameter WIDTH_R = 8
) (
    input                            clk,
    input                            rstn,
    input                            vld_in,
    input      [        WIDTH_M-1:0] multiplicand,
    input      [        WIDTH_R-1:0] multiplier,
    output     [WIDTH_M+WIDTH_R-1:0] mul_out,
    output reg                       done
);
    reg IDLE = 2'b00, ADD = 2'b01, SHIFT = 2'b11, OUTPUT = 2'b10;

    reg [1:0] current_state, next_state;

    reg [WIDTH_M+WIDTH_R+2:0] add1;
    reg [WIDTH_M+WIDTH_R+2:0] sub1;
    reg [WIDTH_M+WIDTH_R+2:0] add_x2;
    reg [WIDTH_M+WIDTH_R+2:0] sub_x2;
    reg [WIDTH_M+WIDTH_R+2:0] p_dct;
    reg [        WIDTH_R-1:0] count;

    always @(posedge clk or negedge rstn)
        if (!rstn) current_state <= IDLE;
        else if (!vld_in) current_state <= IDLE;
        else current_state <= next_state;

    always @* begin
        next_state = 2'bx;
        case (current_state)
            IDLE:    if (vld_in) next_state = ADD;
	 else next_state = IDLE;
            ADD:     next_state = SHIFT;
            SHIFT:   if (count == WIDTH_R / 2) next_state = OUTPUT;
 else next_state = ADD;
            OUTPUT:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            {add1, sub1, add_x2, sub_x2, p_dct, count, done} <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    add1   <= {{2{multiplicand[WIDTH_R-1]}}, multiplicand, {WIDTH_R + 1{1'b0}}};
                    sub1   <= {-{{2{multiplicand[WIDTH_R-1]}}, multiplicand}, {WIDTH_R + 1{1'b0}}};
                    add_x2 <= {{multiplicand[WIDTH_M-1], multiplicand, 1'b0}, {WIDTH_R + 1{1'b0}}};
                    sub_x2 <= {-{multiplicand[WIDTH_M-1], multiplicand, 1'b0}, {WIDTH_R + 1{1'b0}}};
                    p_dct  <= {{WIDTH_M + 1{1'b0}}, multiplier, 1'b0};
                    count  <= 0;
                    done   <= 0;
                end
                ADD: begin
                    case (p_dct[2:0])
                        3'b000, 3'b111: p_dct <= p_dct;
                        3'b001, 3'b010: p_dct <= p_dct + add1;
                        3'b101, 3'b110: p_dct <= p_dct + sub1;
                        3'b100:         p_dct <= p_dct + sub_x2;
                        3'b011:         p_dct <= p_dct + add_x2;
                        default:        p_dct <= p_dct;
                    endcase
                    count <= count + 1;
                end
                SHIFT: p_dct <= {p_dct[WIDTH_M+WIDTH_R+2], p_dct[WIDTH_M+WIDTH_R+2], p_dct[WIDTH_M+WIDTH_R+2:2]};

                OUTPUT: begin
                    done <= 1;
                end
            endcase
        end
    end

    assign mul_out = p_dct[WIDTH_M+WIDTH_R:1];

endmodule
