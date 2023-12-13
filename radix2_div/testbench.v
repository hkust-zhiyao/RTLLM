`timescale 1ns/1ps

module radix2_div_tb();

parameter DATAWIDTH = 8;
parameter TIME_LIMIT = 100;

reg  clk;
reg  rstn;       
reg  en;    
wire ready; 
wire vld_out;    
reg  [DATAWIDTH-1:0]    dividend; 
reg  [DATAWIDTH-1:0]    divisor;
wire [DATAWIDTH-1:0]    quotient;
wire [DATAWIDTH-1:0]    remainder;

radix2_div #(
    .DATAWIDTH                     ( DATAWIDTH  ))
     u1(
            .clk                   ( clk        ),
            .rstn                  ( rstn       ),
            .en                    ( en         ),
            .ready                 ( ready      ),
            .dividend              ( dividend   ),
            .divisor               ( divisor    ),
            .quotient              ( quotient   ),
            .remainder             ( remainder  ),
            .vld_out               ( vld_out    )
);

always #1 clk = ~clk;

integer i;
integer error = 0;
reg [31:0] start_time;
initial begin
  clk = 1;
  rstn = 1;
  en = 0;
  #2 rstn = 0; 
  #2 rstn = 1;
  repeat(2) @(posedge clk);

  for(i=0;i<10;i=i+1) begin
    en <= 1;
    dividend <= $urandom() % 200;
    divisor <= $urandom() % 100;
    start_time = $time;
    // Wait for the specified events or exceed the time limit
    repeat (TIME_LIMIT) begin
      if (($time - start_time) > TIME_LIMIT) begin
        $fatal("Error: Testbench exceeded time limit of %0t seconds", TIME_LIMIT);
      end
      if (ready == 1 && vld_out == 1) begin
        $display("Test Case %d - Dividend: %d, Divisor: %d, Quotient: %d, Remainder: %d", i + 1, dividend, divisor, quotient, remainder);
        error = (quotient != dividend / divisor) || (remainder != dividend % divisor) ? error + 1 : error;
        break;
      end
      #1; // Advance time by 1 time unit
    end

    if (ready != 1 || vld_out != 1) begin
      $fatal("Error: Testbench exceeded time limit of %0t seconds", TIME_LIMIT);
    end
  end
  if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Failed===========", error);
    end

$finish;

end

endmodule


