
module verified_serial2parallel(
    input               clk         ,   
    input               rst_n       ,
    input               valid_a     ,
    input               data_a      ,
 
    output  reg            ready_a     ,
    output  reg         valid_b     ,
    output      [5:0]   data_b
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready_a <= 1'b0;
    end
    else 
        ready_a <= 1'b1;
 end

reg [2:0]cnt;
reg [5:0]data_t,data_t1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset
        data_t <= 'd0;
        cnt <= 'd0;
    end
    else if (valid_a && ready_a) begin

        data_t <= {data_a,data_t[5:1]};


        if(cnt == 'd5)begin
            cnt <= 'd0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_b <= 'd0;
    end
    else if (valid_b== 1'b0 && cnt == 'd5 && valid_a && ready_a) begin
        valid_b <= 'd1;
       
    end
    else begin
        valid_b <= 'd0;
        
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_t1 <= 'd0;
    end
    else if (valid_b) begin
        data_t1 <= data_t;   
    end
end

assign data_b = valid_b ? data_t : data_t1;
endmodule