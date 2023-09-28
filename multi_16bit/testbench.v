module tb_verified_multi_16bit;
  
  reg clk;
  reg rst_n;
  reg start;
  reg [15:0] ain;
  reg [15:0] bin;
  wire [31:0] yout;
  wire done;

  integer i; // Declare the loop variable here
  integer fail_count; // Declare a variable to count the failures
  integer timeout; // Declare a timeout counter here
  reg [31:0] expected_product; // Declare a variable to store the expected product

  // Instantiate the module
  verified_multi_16bit uut (
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
    fail_count = 0;
    rst_n = 1; // De-assert reset
    start = 0; // Initialize start

    // Perform reset
    rst_n = 0;
    #10;
    rst_n = 1;
    #10;

    for (i = 0; i < 100; i = i + 1) begin
      ain = $random;
      bin = $random;
      start = 1; // Start the operation
      
      #10; // Wait for the output to be computed
      
      // Calculate expected product
      expected_product = ain * bin;
      
      // We need to wait until the operation is done
      timeout = 0; // Initialize timeout counter
      while(!done && timeout < 1000) begin // Check for timeout
        #10;
        timeout = timeout + 1;
      end
      
      // Check for timeout
      if (timeout >= 1000) begin
        $display("Timeout: operation did not complete within 1000 clock cycles");
        fail_count = fail_count + 1; // Increment the failure count
        start = 0; // Stop the operation
        $finish; // Skip to the next iteration
      end
      
      if (yout !== expected_product) begin
        $display("Test failed: ain = %h, bin = %h, yout = %h, expected = %h", ain, bin, yout, expected_product);
        fail_count = fail_count + 1; // Increment the failure count
      end
      else begin
        $display("===========Your Design Passed===========");
      end
      
      start = 0; // Stop the operation
    end
    
    $display("Test completed with %d failures", fail_count);
  end

endmodule