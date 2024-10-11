`timescale 1ns/1ns

/***************************************RAM*****************************************/
module dual_port_RAM #(parameter DEPTH = 16,  parameter WIDTH = 8)
(
	 input wclk	,
	 input wenc	,
	 input [$clog2(DEPTH)-1:0] waddr  ,
	 input [WIDTH-1:0] wdata ,
	 input rclk	,
	 input renc	,
	 input [$clog2(DEPTH)-1:0] raddr ,
	 output reg [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
end 

endmodule  


/**************************************AFIFO*****************************************/
module verified_asyn_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk	, 
	input 					rclk	,   
	input 					wrstn	,
	input					rrstn	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire				wfull	,
	output wire				rempty	,
	output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);


reg 	[ADDR_WIDTH:0]	waddr_bin;
reg 	[ADDR_WIDTH:0]	raddr_bin;

always @(posedge wclk or negedge wrstn) begin
	if(~wrstn) begin
		waddr_bin <= 'd0;
	end 
	else if(!wfull && winc)begin
		waddr_bin <= waddr_bin + 1'd1;
	end
end
always @(posedge rclk or negedge rrstn) begin
	if(~rrstn) begin
		raddr_bin <= 'd0;
	end 
	else if(!rempty && rinc)begin
		raddr_bin <= raddr_bin + 1'd1;
	end
end

wire 	[ADDR_WIDTH:0]	waddr_gray;
wire 	[ADDR_WIDTH:0]	raddr_gray;
reg 	[ADDR_WIDTH:0]	wptr;
reg 	[ADDR_WIDTH:0]	rptr;
assign waddr_gray = waddr_bin ^ (waddr_bin>>1);
assign raddr_gray = raddr_bin ^ (raddr_bin>>1);
always @(posedge wclk or negedge wrstn) begin 
	if(~wrstn) begin
		wptr <= 'd0;
	end 
	else begin
		wptr <= waddr_gray;
	end
end
always @(posedge rclk or negedge rrstn) begin 
	if(~rrstn) begin
		rptr <= 'd0;
	end 
	else begin
		rptr <= raddr_gray;
	end
end

reg		[ADDR_WIDTH:0]	wptr_buff;
reg		[ADDR_WIDTH:0]	wptr_syn;
reg		[ADDR_WIDTH:0]	rptr_buff;
reg		[ADDR_WIDTH:0]	rptr_syn;
always @(posedge wclk or negedge wrstn) begin 
	if(~wrstn) begin
		rptr_buff <= 'd0;
		rptr_syn <= 'd0;
	end 
	else begin
		rptr_buff <= rptr;
		rptr_syn <= rptr_buff;
	end
end
always @(posedge rclk or negedge rrstn) begin 
	if(~rrstn) begin
		wptr_buff <= 'd0;
		wptr_syn <= 'd0;
	end 
	else begin
		wptr_buff <= wptr;
		wptr_syn <= wptr_buff;
	end
end

assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH:ADDR_WIDTH-1],rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr == wptr_syn);

/***********RAM*********/
wire 	wen	;
wire	ren	;
wire 	wren;//high write
wire [ADDR_WIDTH-1:0]	waddr;
wire [ADDR_WIDTH-1:0]	raddr;
assign wen = winc & !wfull;
assign ren = rinc & !rempty;
assign waddr = waddr_bin[ADDR_WIDTH-1:0];
assign raddr = raddr_bin[ADDR_WIDTH-1:0];

dual_port_RAM #(.DEPTH(DEPTH),
				.WIDTH(WIDTH)
)dual_port_RAM(
	.wclk (wclk),  
	.wenc (wen),  
	.waddr(waddr[ADDR_WIDTH-1:0]),  //The depth is logarithmic to 2 to get the bit width of the address
	.wdata(wdata),       	//data_write
	.rclk (rclk), 
	.renc (ren), 
	.raddr(raddr[ADDR_WIDTH-1:0]),   
	.rdata(rdata)  		
);

endmodule