module fmultiplier_tb;

reg [31:0] a, b;
wire [31:0] z;
reg clk, rst;

float_multi uut(clk , rst, a, b, z);
integer error = 0;
initial begin
	clk <= 0;
	rst <= 1;
	repeat(17000)
		#5 clk <= ~clk;
end

initial #13 rst <= 0;

initial begin
// $monitor("a=%b, b=%b, z=%b", a,b,z);
	#3
	repeat(2) begin
		#80
		a = 32'b00111110100110011001100110011010;
		b = 32'b00111110100110011001100110011010;
	end
	
	#80
    error = (z==32'b00111101101110000101000111101100) ? error:error+1;
    if (error == 0) begin
            $display("=========== Your Design Passed ===========");
            end
    else begin
        $display("=========== Test completed with %d/20 failures ===========", error);
    end
    $finish;
end


endmodule