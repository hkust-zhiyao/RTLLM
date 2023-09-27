`timescale 1ns/1ps
 
module add16_tb();
 
    reg     [15:0]  a;
    reg         [15:0]  b;
    reg                     c_up;
     
    wire        [15:0]  y;
    wire                    Co;
 
     
    wire    [16:0]  tb_sum ;

    wire                tb_co ;
     
    assign tb_sum = a + b;
    assign tb_co  = tb_sum[16];

    integer i;
    integer error = 0;

    initial begin
        for (i = 0; i < 100; i = i + 1) begin
            a = {$random};
            b = {$random};
            c_up = 0;  
            
            #20;
            error = (y !== tb_sum[15:0] || Co !== tb_co) ? error+1 : error ; 
        end

        if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Test completed with %d /100 failures===========", error);
        end
     
    end
     
    verified_adder_16bit uut(
        .a          (a),
        .b          (b),
        .c_up       (c_up),   
     
        .y          (y),
        .Co     (Co)
    );
 
endmodule