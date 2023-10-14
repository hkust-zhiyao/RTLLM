module chatgpt_generate_traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output wire[7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

reg [5:0] timer;
reg [3:0] state;
parameter IDLE = 4'b0000;
parameter GREEN = 4'b0001;
parameter YELLOW = 4'b0010;
parameter RED = 4'b0100;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        timer <= 6'b0;
        red <= 0;
        yellow <= 0;
        green <= 1;
    end else begin
        case (state)
            IDLE:
                if (pass_request) begin
                    state <= GREEN;
                    timer <= 6'd60;
                    green <= 1;
                end
            GREEN:
                if (timer == 6'd0) begin
                    state <= YELLOW;
                    timer <= 6'd5;
                    green <= 0;
                    yellow <= 1;
                end else if (pass_request) begin
                    if (timer > 6'd10) begin
                        timer <= 6'd10;
                    end
                end
            YELLOW:
                if (timer == 6'd0) begin
                    state <= RED;
                    timer <= 6'd10;
                    yellow <= 0;
                    red <= 1;
                end
            RED:
                if (timer == 6'd0) begin
                    state <= IDLE;
                    timer <= 6'd60;
                    red <= 0;
                    green <= 1;
                end
        endcase
        if (timer > 6'd0) begin
            timer <= timer - 1;
        end
    end
end

assign clock = timer;

endmodule
