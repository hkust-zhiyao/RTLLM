module verified_fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [2:0] ST_cr,ST_nt;

parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;
parameter s5 = 3'b101;

always@(posedge CLK or posedge RST) begin
	if(RST)
		ST_cr <= s0;
	else
		ST_cr <= ST_nt;
end

always@(*) begin
	case(ST_cr)
		s0:begin
			if (IN==0)
				ST_nt = s0;
			else
				ST_nt = s1;
		end
		
		s1:begin
                        if (IN==0)
                                ST_nt = s2;
                        else
                                ST_nt = s1;
                end

                s2:begin
                        if (IN==0)
                                ST_nt = s3;
                        else
                                ST_nt = s1;
                end

                s3:begin
                        if (IN==0)
                                ST_nt = s0;
                        else
                                ST_nt = s4;
                end

                s4:begin
                        if (IN==0)
                                ST_nt = s2;
                        else
                                ST_nt = s5;
                end

                s5:begin
                        if (IN==0)
                                ST_nt = s2;
                        else
                                ST_nt = s1;
                end

	endcase
end

always@(*) begin
        if(RST)
                MATCH  <= 0;
        else if (ST_cr == s4 && IN == 1)
                MATCH  <= 1;
	else 
		MATCH  <= 0;
end

endmodule