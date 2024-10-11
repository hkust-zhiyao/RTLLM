module float_multi(clk, rst, a, b, z);

input clk, rst;
input [31:0] a, b;
output reg [31:0] z;

reg [2:0] counter;

reg [23:0] a_mantissa, b_mantissa, z_mantissa; //Mantissa
reg [9:0] a_exponent, b_exponent, z_exponent; //EXPONENTS
reg a_sign, b_sign, z_sign; // Sign_Bit

reg [49:0] product;

reg guard_bit, round_bit, sticky;

always @(posedge clk or rst) begin
	if(rst)
		counter <= 0;
	else
		counter <= counter + 1;
end


always @(counter) begin
	if(counter == 3'b001) begin 
	//IEEE 754 Representation
		a_mantissa <= a[22:0];
	        b_mantissa <= b[22:0];
	        a_exponent <= a[30:23] - 127;
        	b_exponent <= b[30:23] - 127;
	        a_sign <= a[31];
        	b_sign <= b[31];
        end
end


always @(counter) begin
	if(counter == 3'b010) begin
		if ((a_exponent == 128 && a_mantissa != 0) || (b_exponent == 128 && b_mantissa != 0)) begin //Not a Number 
          		z[31] <= 1;
          		z[30:23] <= 255;
          		z[22] <= 1;
          		z[21:0] <= 0;
          	end
          	else if (a_exponent == 128) begin //INF A
          		z[31] <= a_sign ^ b_sign;
          		z[30:23] <= 255;
          		z[22:0] <= 0;
          		if (($signed(b_exponent) == -127) && (b_mantissa == 0)) begin //NAN IF B = 0
            			z[31] <= 1;
            			z[30:23] <= 255;
	        	    	z[22] <= 1;
        		    	z[21:0] <= 0;
          		end
          	end
          	else if (b_exponent == 128) begin //INF B
          		z[31] <= a_sign ^ b_sign;
          		z[30:23] <= 255;
          		z[22:0] <= 0;
          		if (($signed(a_exponent) == -127) && (a_mantissa == 0)) begin //NAN IF A = 0
            			z[31] <= 1;
            			z[30:23] <= 255;
	        	    	z[22] <= 1;
        		    	z[21:0] <= 0;
          		end
          	end
	          else if (($signed(a_exponent) == -127) && (a_mantissa == 0)) begin //0 if A = 0
       		 z[31] <= a_sign ^ b_sign; //Sign_Bit 
       		 z[30:23] <= 0; 
        	 	 z[22:0] <= 0;
        	  end
        	  else if (($signed(b_exponent) == -127) && (b_mantissa == 0)) begin //0 if B = 0
        	 	 z[31] <= a_sign ^ b_sign;
        	  	 z[30:23] <= 0;
        	  	 z[22:0] <= 0;
        	  end
        	  else begin
        	  	if ($signed(a_exponent) == -127) //DENORMALIZING A
        	    		a_exponent <= -126;
        	  	else
        	    		a_mantissa[23] <= 1;
            		
        	    	if ($signed(b_exponent) == -127) //DENORMALIZING B
        	    		b_exponent <= -126;
        	  	else
        	    		b_mantissa[23] <= 1;
        	  end
        end
end


always @(counter) begin
	if(counter == 3'b011) begin
		if (~a_mantissa[23]) begin //NORMALIZE A
	        	a_mantissa <= a_mantissa << 1;
	       	a_exponent <= a_exponent - 1;
	        end
	        if (~b_mantissa[23]) begin //NORMALIZE B
	        	b_mantissa <= b_mantissa << 1;
	       	b_exponent <= b_exponent - 1;
	        end
	end
end


always @(counter) begin
	if(counter == 3'b100) begin //GET THE SIGNS XORED and EXPONENTS ADDED and GET THE INTERMEDIATE MANTISSA MULTIPLICATION
		z_sign <= a_sign ^ b_sign;
	        z_exponent <= a_exponent + b_exponent + 1 ;
        	product <= a_mantissa * b_mantissa * 4;
	end
end


always @(counter) begin
	if(counter == 3'b101) begin
		z_mantissa <= product[49:26];
       	guard_bit <= product[25];
      		round_bit <= product[24];
      		sticky <= (product[23:0] != 0);
	end
end

always @(counter) begin
	if(counter == 3'b110) begin
		if ($signed(z_exponent) < -126) begin
        		z_exponent <= z_exponent + (-126 -$signed(z_exponent));
    			z_mantissa <= z_mantissa >> (-126 -$signed(z_exponent));
     			guard_bit <= z_mantissa[0];
       		round_bit <= guard_bit;
       		sticky <= sticky | round_bit;
        	end
		else if (z_mantissa[23] == 0) begin
        		z_exponent <= z_exponent - 1;
        		z_mantissa <= z_mantissa << 1;
        		z_mantissa[0] <= guard_bit;
        		guard_bit <= round_bit;
        		round_bit <= 0;
        	end
	        else if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
        		z_mantissa <= z_mantissa + 1;
          		if (z_mantissa == 24'hffffff)
            			z_exponent <=z_exponent + 1;
        	end
        end
end

always @(counter) begin
	if(counter == 3'b111) begin
		z[22:0] <= z_mantissa[22:0];
        	z[30:23] <= z_exponent[7:0] + 127;
        	z[31] <= z_sign;
        	if ($signed(z_exponent) == -126 && z_mantissa[23] == 0)
          		z[30:23] <= 0;
        	if ($signed(z_exponent) > 127) begin //IF OVERFLOW RETURN INF
          		z[22:0] <= 0;
          		z[30:23] <= 255;
          		z[31] <= z_sign;
        	end
	end
end


endmodule