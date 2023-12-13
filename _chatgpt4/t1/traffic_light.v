module traffic_light(
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg red,
    output reg yellow,
    output reg green,
    output [7:0] clock
);

    // State encoding
    parameter s1_red = 2'b00,
              s2_yellow = 2'b01,
              s3_green = 2'b10;

    // Internal variables
    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd60; // Reset count to default green time
        end else if (state == s3_green && pass_request && cnt > 10) begin
            cnt <= 8'd10; // Pedestrian request, shorten green if > 10
        end else if (cnt == 0) begin
            case (state)
                s1_red:    cnt <= 8'd60; // Red to green
                s2_yellow: cnt <= 8'd10; // Yellow to red
                s3_green:  cnt <= 8'd5;  // Green to yellow
                default:   cnt <= 8'd60;
            endcase
        end else begin
            cnt <= cnt - 1; // Decrement counter
        end
    end

    // FSM logic for state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= s1_red; // Reset to red state
        end else begin
            state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            s1_red:    next_state = (cnt == 0) ? s3_green : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red : s2_yellow;
            s3_green:  next_state = (cnt == 0 || (pass_request && cnt <= 10)) ? s2_yellow : s3_green;
            default:   next_state = s1_red;
        endcase
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else begin
            case (state)
                s1_red: begin
                    red <= 1;
                    yellow <= 0;
                    green <= 0;
                end
                s2_yellow: begin
                    red <= 0;
                    yellow <= 1;
                    green <= 0;
                end
                s3_green: begin
                    red <= 0;
                    yellow <= 0;
                    green <= 1;
                end
            endcase
        end
    end

    // Assign the internal counter to an output port for monitoring
    assign clock = cnt;

endmodule