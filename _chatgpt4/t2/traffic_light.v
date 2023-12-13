module traffic_light (
    input clk,
    input rst_n,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State parameters
    parameter idle      = 2'b00,
              s1_red    = 2'b01,
              s2_yellow = 2'b10,
              s3_green  = 2'b11;

    // Internal counter and state
    reg [7:0] cnt;
    reg [1:0] state;

    // Next state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd60; // Start with green light duration
        end else begin
            case (state)
                idle: begin
                    state <= s1_red;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60; // Green light duration
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10; // Red light duration
                    end
                end
                s3_green: begin
                    if (cnt == 0 || (cnt > 8'd10 && pass_request)) begin
                        state <= s2_yellow;
                        cnt <= 8'd5; // Yellow light duration
                    end
                end
                default: state <= idle;
            endcase
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd60; // Reset to green light duration
        end else if (state == s3_green && pass_request && cnt > 8'd10) begin
            cnt <= 8'd10; // Shorten green if pedestrian button is pressed
        end else if (cnt > 0) begin
            cnt <= cnt - 1; // Decrement counter
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            // Set outputs based on state
            red <= (state == s1_red);
            yellow <= (state == s2_yellow);
            green <= (state == s3_green);
        end
    end

    // Assign internal counter to output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 8'd0;
        end else begin
            clock <= cnt;
        end
    end

endmodule