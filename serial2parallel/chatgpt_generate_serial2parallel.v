module chatgpt_generate_serial2parallel(
  input               clk,
  input               rst_n,
  input               valid_a,
  input               data_a,
  output reg          ready_a,
  output reg          valid_b,
  output reg  [5:0]   data_b
);

  reg [5:0] internal_data;
  reg [2:0] count;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the circuit
      internal_data <= 6'b0;
      count <= 3'b0;
      ready_a <= 1'b0;
      valid_b <= 1'b0;
      data_b <= 6'b0;
    end else begin
      // Data concatenation process when valid data is received
      if (valid_a) begin
        internal_data[count] <= data_a;
        count <= count + 1;
        ready_a <= (count == 3) ? 1'b0 : 1'b1; // Ready is low after receiving 6 bits
      end else begin
        ready_a <= 1'b0; // Ready is low during data concatenation
      end
      
      // Output data on valid_b when 6 bits are received
      if (count == 3) begin
        data_b <= internal_data;
        valid_b <= 1'b1; // Valid is high after 6 bits are received
      end else begin
        valid_b <= 1'b0; // Valid is low during data concatenation
      end
      
      // Reset the internal_data and count after sending the output data
      if (valid_b && ready_a) begin
        internal_data <= 6'b0;
        count <= 3'b0;
      end
    end
  end

endmodule

