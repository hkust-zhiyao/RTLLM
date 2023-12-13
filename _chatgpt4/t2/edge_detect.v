module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    // Register to hold the previous value of 'a'
    reg a_prev;

    // Detect edges on the positive clock edge and when reset is not asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear the rise and down signals and the stored previous value of 'a'
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // On each clock edge, update the rise and down signals based on the current and previous values of 'a'
            rise <= (a_prev == 0) && (a == 1);  // Set 'rise' if 'a' was 0 and is now 1
            down <= (a_prev == 1) && (a == 0);  // Set 'down' if 'a' was 1 and is now 0
            a_prev <= a;  // Store the current value of 'a' for the next comparison
        end
    end

endmodule