module edge_detect(
    input clk,      // Clock signal
    input rst_n,    // Reset signal (active low)
    input a,        // Input signal
    output reg rise, // Output signal indicating a rising edge
    output reg down  // Output signal indicating a falling edge
);

    // Register to hold the previous value of 'a'
    reg a_prev;

    // Edge detection is done on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: outputs and previous value register are reset
            rise <= 1'b0;
            down <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            // On every clock edge, update the rise and down signals
            rise <= (a_prev == 1'b0 && a == 1'b1); // Rising edge detected
            down <= (a_prev == 1'b1 && a == 1'b0); // Falling edge detected
            
            // Update the previous value of 'a'
            a_prev <= a;
        end
    end

endmodule