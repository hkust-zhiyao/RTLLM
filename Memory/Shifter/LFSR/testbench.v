module lfsr_tb();
reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

LFSR DUT(out_tb,clk_tb,rst_tb);

initial
begin
    clk_tb = 0;
    rst_tb = 1;
    #15;
    
    rst_tb = 0;
    #200;
    // $display("Failed: out=%b (expected 1101)", out_tb);
    if (out_tb == 4'b1101) begin
      $display("=========== Your Design Passed ===========");
    end
    else begin
      $display("=========== Failed ===========");
    end
    $finish;
end

always
begin
    #5;
    clk_tb = ~ clk_tb;
end


endmodule