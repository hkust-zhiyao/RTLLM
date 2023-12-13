module traffic_light(
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State declarations
    parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;

    // Internal counter
    reg [7:0] cnt;

    // Current state
    reg [1:0] state;

    // Next state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case (state)
                idle: state <= s1_red; // Start with red
                s1_red: if (cnt == 0) state <= s3_green; // Move to green after red
                s2_yellow: if (cnt == 0) state <= s1_red; // Move to red after yellow
                s3_green: if (cnt == 0) state <= s2_yellow; // Move to yellow after green
                default: state <= idle;
            endcase
        end
    end

    // Counter logic to handle timing and pedestrian button
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10; // Reset to 10 at start
        end else begin
            if (cnt == 0) begin
                // Set the counter based on the current state when count reaches 0
                case (state)
                    s1_red: cnt <= 60;
                    s2_yellow: cnt <= 5;
                    s3_green: cnt <= 10;
                    default: cnt <= 10;
                endcase
            end else if (pass_request && state == s3_green && cnt > 10) begin
                cnt <= 10; // Shorten green time if pass_request is active
            end else begin
                cnt <= cnt - 1; // Normal countdown
            end
        end
    end

    // Assign the current count value to the clock output
    always @(cnt) begin
        clock <= cnt;
    end

    // Output logic for the traffic light signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            case (state)
                s1_red: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                s2_yellow: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                s3_green: begin
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

endmodule