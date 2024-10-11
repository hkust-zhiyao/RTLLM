`timescale 1ns/1ps
module verified_radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

    reg [7:0] dividend_save, divisor_save;
    reg [15:0] SR;                  
    reg [8 :0] NEG_DIVISOR;        
    wire [7:0] REMAINER, QUOTIENT;
    assign REMAINER = SR[15:8];
    assign QUOTIENT = SR[7: 0];

    wire [7:0] divident_abs;
    wire [8:0] divisor_abs;
    wire [7:0] remainer, quotient;

    assign divident_abs = (sign & dividend[7]) ? ~dividend + 1'b1 : dividend;
    assign remainer = (sign & dividend_save[7]) ? ~REMAINER + 1'b1 : REMAINER;
    assign quotient = sign & (dividend_save[7] ^ divisor_save[7]) ? ~QUOTIENT + 1'b1 : QUOTIENT;
    assign result = {remainer,quotient};

    wire CO;
    wire [8:0] sub_result;
    wire [8:0] mux_result;

    assign {CO,sub_result} = {1'b0,REMAINER} + NEG_DIVISOR;

    assign mux_result = CO ? sub_result : {1'b0,REMAINER};

    reg [3:0] cnt;
    reg start_cnt;
    always @(posedge clk) begin
        if(rst) begin
            SR <= 0;
            dividend_save <= 0;
            divisor_save <= 0;

            cnt <= 0;
            start_cnt <= 1'b0;
        end
        else if(~start_cnt & opn_valid & ~res_valid) begin
            cnt <= 1;
            start_cnt <= 1'b1;
        
            dividend_save <= dividend;
            divisor_save <= divisor;

            SR[15:0] <= {7'b0,divident_abs,1'b0}; 
            NEG_DIVISOR <= (sign & divisor[7]) ? {1'b1,divisor} : ~{1'b0,divisor} + 1'b1; 
        end
        else if(start_cnt) begin
            if(cnt[3]) begin    
                cnt <= 0;
                start_cnt <= 1'b0;
                
                SR[15:8] <= mux_result[7:0];
                SR[0] <= CO;
            end
            else begin
                cnt <= cnt + 1;

                SR[15:0] <= {mux_result[6:0],SR[7:1],CO,1'b0}; 
            end
        end
    end

    wire data_go;
    assign data_go = res_valid & res_ready;
    always @(posedge clk) begin
        res_valid <= rst     ? 1'b0 :
                     cnt[3]  ? 1'b1 :
                     data_go ? 1'b0 : res_valid;
    end
endmodule
