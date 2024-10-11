module sequence_detector(
     input  clk, 
     input  rst_n,
     input  data_in, 
     output sequence_detected				
     );

       
parameter        IDLE = 5'b00001;
parameter        S1   = 5'b00010;
parameter 	     S2   = 5'b00100;
parameter        S3   = 5'b01000;
parameter        S4   = 5'b10000; 


reg [4:0]		 curr_state;
reg [4:0] 		 next_state;


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
	    curr_state <= IDLE;
    end
    else begin
	    curr_state <= next_state;
    end
end


always@(*) begin
    if(!rst_n) begin
	    next_state <= IDLE;
    end
    else begin
	    case(curr_state)
	        IDLE  :next_state = data_in?S1:IDLE;
	        S1	  :next_state = data_in?S1:S2;
	        S2	  :next_state = data_in?S1:S3;
	        S3	  :next_state = data_in?S4:IDLE;
	        S4	  :next_state = data_in?S1:S2;
	        default:next_state = IDLE;	
	    endcase
    end
end

assign sequence_detected = (curr_state ==S4) ? 1'b1 : 1'b0;

endmodule