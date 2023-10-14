module chatgpt_generate_pulse_detect (
    input                  clk_fast,   // Clock input from domain A (10x faster)
    input                  clk_slow,   // Clock input from domain B (slower)
    input                  rst_n,      // Active low reset
    input                  data_in,    // Input data from clk_fast domain
    output reg             data_out    // Output data synchronized to clk_slow domain
);

// Internal signals for domain crossing
reg [3:0]  sync_cnt;
reg        clk_slow_prev;
reg        data_in_sync, data_in_prev;

always @(posedge clk_slow or negedge rst_n) begin
    if (!rst_n) begin
        data_in_sync <= 1'b0;
        sync_cnt <= 4'b0;
    end else begin
        // Synchronize data_in from clk_fast to clk_slow domain
        data_in_prev <= data_in;
        if (sync_cnt == 4'b1001) // Synchronize after 10 cycles of clk_slow
            data_in_sync <= data_in_prev;
        else
            sync_cnt <= sync_cnt + 1;
    end
end

always @(posedge clk_slow or negedge rst_n) begin
    if (!rst_n) begin
        clk_slow_prev <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Detect a single clock-width pulse in the clk_slow domain
        clk_slow_prev <= clk_slow;
        if (clk_slow && !clk_slow_prev)
            data_out <= data_in_sync; // Output synchronized data_in pulse
        else
            data_out <= 1'b0;
    end
end

endmodule
