`timescale 1ns/1ns

module tb_verified_signal_generator;
  
  reg clk;
  reg rst_n;
  reg [1:0] wave_choise;
  wire [4:0] wave;
  // Instantiate the module
  verified_signal_generator uut (
    .clk(clk), 
    .rst_n(rst_n),
    .wave_choise(wave_choise), 
    .wave(wave)
  );
    integer i;
  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  integer error = 0;
  initial begin
    clk = 0; // Initialize clock
    rst_n = 1; // De-assert reset

    // Perform reset
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;
    wave_choise = 0;
    $display("At time %t, wave choice = %d, wave = %b", $time, wave_choise, wave);
    error = (wave == 5'b00000)? error : error+1; 
    #100;
    wave_choise = 1;
    $display("At time %t, wave choice = %d, wave = %b", $time, wave_choise, wave);
    error = (wave == 5'bx0x00)? error : error+1;
    #100;
    wave_choise = 2;
    $display("At time %t, wave choice = %d, wave = %b", $time, wave_choise, wave); 
    error = (wave == 5'bxxxxx)? error : error+1;
    #100;

    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d / 3 failures===========", error);
    $display("We suggest opening the -gui interface to view the waveform and \nconfirm whether it meets the design requirements.");
    end

    $finish; // End of test
  end

endmodule
