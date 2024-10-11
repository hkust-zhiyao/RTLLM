module tb_signal_generator;
reg				clk,rst_n;
wire[4:0]		wave;

signal_generator uut(
				.clk(clk),
				.rst_n(rst_n),
				.wave(wave)
				);

reg[31:0]reference[0:99];

integer i = 0;
integer error = 0;
// integer outfile;
initial begin
      $readmemh("tri_gen.txt",reference);
			clk = 0;
      rst_n = 0;
			#10
      rst_n =1;
      // outfile = $fopen("tri_gen.txt", "w");
			repeat(100) begin
        // $fwrite(outfile, "%h\n", wave);
        // $display(wave);
        error=(wave==reference[i])?error:error+1;
        #10;
        i = i+1;
      end
      // $fclose(outfile);
      if(error==0)
      begin
        $display("===========Your Design Passed===========");
            end
      else
      begin
        $display("===========Error===========");
      end
      $finish;
end
 
always #5 clk =~clk;
 
endmodule

