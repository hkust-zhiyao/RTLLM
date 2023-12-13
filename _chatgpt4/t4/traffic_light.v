module traffic_light(
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // Parameters for the traffic light timing
    parameter GREEN_TIME = 60;
    parameter YELLOW_TIME = 5;
    parameter RED_TIME = 10;

    // State enumeration
    parameter IDLE = 2'b00, S1_RED = 2'b01, S2_YELLOW = 2'b10, S3_GREEN = 2'b11;

    // Registers
    reg [7:0] cnt;
    reg [1:0] state;
    reg [1:0] next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and timer count down
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= RED_TIME;
            next_state <= S1_RED;
        end else begin
            case (state)
                IDLE: begin
                    cnt <= RED_TIME;
                    next_state <= S1_RED;
                end
                S1_RED: begin
                    if (cnt == 0) begin
                        cnt <= GREEN_TIME;
                        next_state <= S3_GREEN;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S2_YELLOW: begin
                    if (cnt == 0) begin
                        cnt <= RED_TIME;
                        next_state <= S1_RED;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S3_GREEN: begin
                    if (pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else if (cnt == 0) begin
                        cnt <= YELLOW_TIME;
                        next_state <= S2_YELLOW;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    cnt <= RED_TIME;
                    next_state <= S1_RED;
                end
            endcase
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            case (next_state)
                S1_RED: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                S2_YELLOW: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                S3_GREEN: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
        end
    end

    // Assign the count value to the output clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 8'b0;
        end else begin
            clock <= cnt;
        end
    end

endmodule