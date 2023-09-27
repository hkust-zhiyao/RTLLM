`timescale  1ns / 1ps

module tb_valid_ready;

// valid_ready Parameters
parameter PERIOD  = 10;


// valid_ready Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [7:0]  data_in                       = 0 ;
reg   valid_a                              = 0 ;
reg   ready_b                              = 0 ;

// valid_ready Outputs
wire  ready_a                              ;
wire  valid_b                              ;
wire  [9:0]  data_out                      ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

verified_accu  verified_accu (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .data_in                 ( data_in   [7:0] ),
    .valid_a                 ( valid_a         ),
    .ready_b                 ( ready_b         ),

    .ready_a                 ( ready_a         ),
    .valid_b                 ( valid_b         ),
    .data_out                ( data_out  [9:0] )
);

initial
begin
    #(PERIOD*1.5+0.01);
    #(PERIOD)   data_in = 8'd1;valid_a = 1;
    #(PERIOD)   data_in = 8'd2;
    #(PERIOD)   data_in = 8'd3;
    #(PERIOD)   data_in = 8'd4;
    #(PERIOD)   data_in = 8'd5;
    #(PERIOD*2) ready_b = 1;
    #(PERIOD)   data_in = 8'd2;
    #(PERIOD)   data_in = 8'd3;
    #(PERIOD)   data_in = 8'd4;valid_a = 0;
    #(PERIOD)   data_in = 8'd5;valid_a = 1;
    #(PERIOD)   data_in = 8'd6;
    #(PERIOD)   ready_b = 1;
    #(PERIOD*2) ready_b = 0;
    $finish;
end

reg [3:0] result [0:12];
initial begin
    result[0] = 4'b0001;
    result[1] = 4'b0011;
    result[2] = 4'b0110;
    result[3] = 4'b1010;
    result[4] = 4'b1010;
    result[5] = 4'b1010;
    result[6] = 4'b0101;
    result[7] = 4'b0111;
    result[8] = 4'b1010;
    result[9] = 4'b1010;
    result[10] = 4'b1111;
    result[11] = 4'b0110;
    result[12] = 4'b1100;
end

integer i;
integer error = 0;
initial
begin
    #((PERIOD) * 3);
    for (i = 0; i < 13; i = i + 1) begin
            #((PERIOD) * 1);
            error = (data_out == result[i]) ? error : error + 1;
    end

    if(error==0)
	begin
		$display("===========Your Design Passed===========");
        end
	else
	begin
		$display("===========Error===========");
	end

end


endmodule
