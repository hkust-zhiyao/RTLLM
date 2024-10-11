`timescale 1ns/1ns

module pulse_detect_tb;
  reg clk;
  reg rst_n;
  reg data_in;
  wire data_out;

  // Instantiate the DUT (Design Under Test)
  pulse_detect dut (
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .data_out(data_out)
  );

  // Generate clock
  initial begin
	clk=0;
	forever #5 clk=~clk;
  end

  integer error = 0;
  initial begin
      // Initialize inputs
      #10;
      rst_n = 0;
      data_in = 0;
      #28;
      rst_n = 1;
      #10      data_in = 0;
      #10      data_in = 0;  
      #10      data_in = 0;
      #10      data_in = 1;
      #10      data_in = 0;
      #10      data_in = 1;
      #10      data_in = 0;
      #10      data_in = 1;
      #10      data_in = 1;
      #10      data_in = 0;
      #10;
      // Finish simulation
      $finish;
  end

  initial begin
    #5;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 0) ? error : error+1;
    #10;
    error = (data_out == 1) ? error : error+1;
    // $display("%b,%b,%b", data_in, data_out, dut.pulse_level1);//1
    #20;
    error = (data_out == 1) ? error : error+1;
    #10;
    if (error == 0) begin
        $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Error===========");
    end
  end
endmodule