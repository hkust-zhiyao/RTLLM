module edge_detect(
    input wire clk,     // Clock signal
    input wire rst_n,   // Active low reset
    input wire a,       // Input signal
    output reg rise,    // Output signal for rising edge
    output reg down     // Output signal for falling edge
);

    // Register to hold the previous state of `a`
    reg a_prev;

    // On every positive edge of the clock, check for edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active low reset: reset all the outputs and previous state
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Reset the rise and down signals on every clock cycle
            rise <= 0;
            down <= 0;

            // Check for a rising edge
            if (a == 1 && a_prev == 0) begin
                rise <= 1;
            end

            // Check for a falling edge
            if (a == 0 && a_prev == 1) begin
                down <= 1;
            end

            // Update previous state of `a`
            a_prev <= a;
        end
    end

endmodule