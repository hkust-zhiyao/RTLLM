module barrel_shifter_tb;
  reg [7:0] in;
  reg [2:0] ctrl;
  wire [7:0] out; 
  
barrel_shifter uut(.in(in), .ctrl(ctrl), .out(out));

integer error = 0;

initial 
    begin
        in= 8'd0;  ctrl=3'd0; //no shift
        #10 in=8'd128; ctrl= 3'd4; //shift 4 bit
        #10 error = (out==8)?error : error+1;
        #10 in=8'd128; ctrl= 3'd2; //shift 2 bit
        #10 error = (out==32)?error : error+1;
        #10 in=8'd128; ctrl= 3'd1; //shift by 1 bit
        #10 error = (out==64)?error : error+1;
        #10 in=8'd255; ctrl= 3'd7; //shift by 7bit
        #10 error = (out==1)?error : error+1;
    // end
    // initial begin
    //     $monitor("Input=%d, Control=%d, Output=%d",in,ctrl,out);
    // end
        if (error == 0) begin
            $display("=========== Your Design Passed ===========");
            end
        else begin
            $display("=========== Test completed with %d failures ===========", error);
        end
        $finish;
    end
endmodule