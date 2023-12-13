module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] count,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
parameter s1_red = 2'b00, s2_yellow = 2'b01, s3_green = 2'b10;

// Internal register for state and counter
reg [1:0] state, next_state;
reg [7:0] cnt, next_cnt;

// Traffic light timing constants
parameter GREEN_TIME = 60, YELLOW_TIME = 5, RED_TIME = 10;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= s1_red;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Next state and counter logic
always @(*) begin
    // Default assignments
    next_state = state;
    next_cnt = cnt;

    case (state)
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
                next_cnt = GREEN_TIME;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
                next_cnt = RED_TIME;
            end
        end
        s3_green: begin
            if (cnt == 0 || (pass_request && cnt > 10)) begin
                next_state = s2_yellow;
                next_cnt = YELLOW_TIME;
            end else if (pass_request) begin
                // If the button is pressed and the remaining time is less than or equal to 10,
                // remain in the current state with the current time
                next_cnt = (cnt <= 10) ? cnt : 10;
            end
        end
        default: begin
            next_state = s1_red;
            next_cnt = RED_TIME;
        end
    end
end

// Output logic for traffic lights
always @(*) begin
    // Default output values
    red = 1'b0;
    yellow = 1'b0;
    green = 1'b0;

    case (state)
        s1_red: red = 1'b1;
        s2_yellow: yellow = 1'b1;
        s3_green: green = 1'b1;
        default: begin
            red = 1'b0;
            yellow = 1'b0;
            green = 1'b0;
        end
    end
end

// Assign the count output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= RED_TIME;
    end else begin
        count <= cnt;
    end
end

endmodule