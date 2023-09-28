module chatgpt_generate_mux(
  input         clk_a,
  input         clk_b,
  input         arstn,
  input         brstn,
  input  [3:0]  data_in,
  input         data_en,
  output reg [3:0] dataout
);

  reg [3:0] internal_data;
  reg [1:0] sync_counter;
  reg [1:0] en_counter;
  reg       sync_started;

  always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
      // Reset the circuit when asynchronous reset is asserted
      internal_data <= 4'b0;
      sync_counter <= 2'b0;
      en_counter <= 2'b0;
      sync_started <= 1'b0;
      dataout <= 4'b0;
    end else begin
      // Synchronize the data_in to the clk_a domain when data_en is high
      if (data_en) begin
        if (en_counter == 2'b11) begin
          internal_data <= data_in;
          sync_started <= 1'b1;
        end else begin
          sync_started <= 1'b0;
        end
        en_counter <= en_counter + 1;
      end else begin
        en_counter <= 2'b0;
      end
      
      // Start synchronization process when data_en is high for 3 B clock cycles
      if (sync_started) begin
        if (sync_counter == 2'b11) begin
          dataout <= internal_data;
        end
        sync_counter <= sync_counter + 1;
      end else begin
        sync_counter <= 2'b0;
      end
    end
  end

  always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
      // Reset the synchronization process when asynchronous reset is asserted on clk_b
      sync_started <= 1'b0;
    end
  end

endmodule

