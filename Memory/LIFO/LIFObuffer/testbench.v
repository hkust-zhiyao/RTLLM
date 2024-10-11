`timescale 1ns / 1ps

module LIFObuffer_tb;

// Inputs
reg [3:0] dataIn;
reg RW;
reg EN;
reg Rst;
reg Clk;

// Outputs
wire [3:0] dataOut;
wire EMPTY;
wire FULL;

// Instantiate the Unit Under Test (UUT)
LIFObuffer uut (
    .dataIn(dataIn),
    .dataOut(dataOut),
    .RW(RW),
    .EN(EN),
    .Rst(Rst),
    .EMPTY(EMPTY),
    .FULL(FULL),
    .Clk(Clk)
);
integer error = 0;
initial begin
    // Initialize Inputs
    dataIn = 4'h0;
    RW = 1'b0;
    EN = 1'b0;
    Rst = 1'b1;
    Clk = 1'b0;

    // Wait 100 ns for global reset to finish
    #100;

    // Add stimulus here
    EN = 1'b1;
    Rst = 1'b1;
    #40;
    Rst = 1'b0;
    RW = 1'b0;
    dataIn = 4'h0;
    #20;
    dataIn = 4'h2;
    #20;
    dataIn = 4'h4;
    #20;
    dataIn = 4'h6;
    #20;
    RW = 1'b1;
    #5;
    // $display(FULL,EMPTY);
    error = (FULL && !EMPTY) ? error : error+1;
    #20;
    // $display(dataOut);
    error = (dataOut==6) ? error : error+1;
    #20;
    // $display(dataOut);
    error = (dataOut==4) ? error : error+1;
    if (error == 0) begin
            $display("=========== Your Design Passed ===========");
            end
        else begin
            $display("=========== Test completed with %d/20 failures ===========", error);
    end
    $finish;
end

always #10 Clk = ~Clk;

endmodule
