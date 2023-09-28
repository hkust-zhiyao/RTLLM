`timescale 1ns/1ns
module chatgpt_generate_signal_generator(
  input               clk,
  input               rst_n,
  input       [1:0]   wave_choise,
  output reg  [4:0]   wave
);

  reg [3:0] counter;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Reset the circuit
      counter <= 4'b0;
      wave <= 5'b0;
    end else begin
      // Increment the counter at each clock cycle
      counter <= counter + 1;
      
      // Generate different waveforms based on wave_choise
      case (wave_choise)
        2'b00: wave <= (counter[3]) ? 5'b10000 : 5'b00000; // Square wave
        2'b01: wave <= counter[3:0];                       // Sawtooth wave
        2'b10: wave <= (counter[3]) ? 5'b00001 : 5'b10000; // Triangular wave
        default: wave <= 5'b0;                             // Default: output zero
      endcase
    end
  end

endmodule

