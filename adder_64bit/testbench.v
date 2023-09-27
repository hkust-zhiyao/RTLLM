module tb_adder64();

parameter   DATA_WIDTH = 64;
parameter   STG_WIDTH  = 16;

reg	        CLK;
reg         RST;
reg         i_en;
wire        o_en;
reg	    [DATA_WIDTH-1:0]    PLUS_A;
reg	    [DATA_WIDTH-1:0]    PLUS_B;
wire	[DATA_WIDTH:0]      SUM_OUT;
wire	[DATA_WIDTH:0]      sum_out_golden;
reg     [DATA_WIDTH:0]      sum_out_golden_ff1;
reg     [DATA_WIDTH:0]      sum_out_golden_ff2;
reg     [DATA_WIDTH:0]      sum_out_golden_ff3;
reg     [DATA_WIDTH:0]      sum_out_golden_ff4;
assign {sum_out_golden} = PLUS_A + PLUS_B;

integer error=0;
initial begin
    CLK         = 0;
    RST         = 0;
    i_en        = 0;
    # 8 RST     = 1;
    i_en        = 1'b1;
    repeat (500) begin
    PLUS_A = $random*$random;
	PLUS_B = $random*$random;
    #4;
    error = (sum_out_golden_ff4 == SUM_OUT) ? error : error+1;
    @(negedge CLK);
    end

    if (error == 0) begin
            $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d /500 failures===========", error);
    end

    $finish;
end

always #2 CLK = ~CLK;

always@(posedge CLK, negedge RST) begin
    if(!RST) begin
        sum_out_golden_ff1          <= 'd0;
        sum_out_golden_ff2          <= 'd0;
        sum_out_golden_ff3          <= 'd0;
        sum_out_golden_ff4          <= 'd0;
    end
    else begin
        sum_out_golden_ff1          <= sum_out_golden;
        sum_out_golden_ff2          <= sum_out_golden_ff1;
        sum_out_golden_ff3          <= sum_out_golden_ff2;
        sum_out_golden_ff4          <= sum_out_golden_ff3;
    end
end
assign {sum_out_golden} = PLUS_A + PLUS_B;


verified_adder_64bit
#(
    .DATA_WIDTH(DATA_WIDTH),
    .STG_WITCH(STG_WIDTH)
)
u_pip_add64
(
.clk      (CLK)       ,
.rst_n    (RST)       ,
.i_en     (i_en)       ,
.adda     (PLUS_A)       ,
.addb     (PLUS_B)       ,
.result   (SUM_OUT)       ,
.o_en     (o_en)    
);

endmodule