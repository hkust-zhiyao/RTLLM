module edge_detect(
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

    // Register to hold the previous value of 'a'
    reg a_prev;

    // Always block for edge detection and output signal generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: active low
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Check for rising edge
            if (a == 1 && a_prev == 0) begin
                rise <= 1;
            end else begin
                rise <= 0;
            end
            // Check for falling edge
            if (a == 0 && a_prev == 1) begin
                down <= 1;
            end else begin
                down <= 0;
            end
            // Update the previous value of 'a'
            a_prev <= a;
        end
    end

endmodule