module tb_multi_16bit;
  
  reg clk;
  reg rst_n;
  reg start;
  reg [15:0] ain;
  reg [15:0] bin;
  wire [31:0] yout;
  wire done;

  integer i; // Declare the loop variable here
  integer fail_count = 0; // Declare a variable to count the failures
  integer timeout; // Declare a timeout counter here
  reg [31:0] expected_product; // Declare a variable to store the expected product

  // Instantiate the module
  multi_16bit uut (
    .clk(clk), 
    .rst_n(rst_n),
    .start(start),
    .ain(ain), 
    .bin(bin), 
    .yout(yout),
    .done(done)
  );
  
  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Randomize inputs and check output
  initial begin
    clk = 0; // Initialize clock
    rst_n = 1; // De-assert reset
    start = 0; // Initialize start

    // Perform reset
    rst_n = 0;
    for (i = 0; i < 100; i = i + 1) begin
      #100;
      rst_n = 1;
      #50;
      ain = $random;
      bin = $random;
      #50;
      start = 1; // Start the operation
      while(done !== 1) begin
        #10;
      end
      expected_product = ain * bin;
      
      if (done == 1) begin
        fail_count = (yout == expected_product)? fail_count:fail_count+1;
      end
      start = 0; // Stop the operation
      rst_n = 0;
      #100;
    end
    
    if (fail_count == 0) begin
        $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d / 100 failures===========", fail_count);
    end
    $finish;
  end

  initial begin
    #50000;
    $finish;
  end

endmodule