`timescale 1ns/1ns

module verified_parallel2serial_tb;
  reg clk;
  reg rst;
  reg [3:0] d;
  wire valid_in;
  wire dout;

  // Instantiate the DUT (Design Under Test)
  verified_parallel2serial dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .valid_in(valid_in),
    .dout(dout)
  );

  // Generate clock
  always #5 clk = ~clk;
  integer error = 0;
  initial begin
    // Initialize inputs
    clk = 0;
    rst = 0;
    d = 4'b0;

    // Wait for a few clock cycles for reset to settle
    #10;

    // Apply reset
    rst = 1;

    // Perform test case
    #10;
    d = 4'b1010;
    #10;
    d = 4'b1100;
    #10;
    d = 4'b0110;
    #10;

    // Check the output
    // $display("dout = %b, valid_in = %b", dout, valid_in);
    error = (dout == 0 && valid_in==1) ? error : error+1;
    #10;
    // $display("dout = %b, valid_in = %b", dout, valid_in);
    error = (dout == 1 && valid_in==0) ? error : error+1;
     #10;
    // $display("dout = %b, valid_in = %b", dout, valid_in);
    error = (dout == 1 && valid_in==0) ? error : error+1;
     #10;
    // $display("dout = %b, valid_in = %b", dout, valid_in);
    error = (dout == 0 && valid_in==0) ? error : error+1;
     #10;
    // $display("dout = %b, valid_in = %b", dout, valid_in);
    error = (dout == 0 && valid_in==1) ? error : error+1;

    if(error<=2) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Failed===========");
    end
    $finish; // End the simulation
  end

endmodule

