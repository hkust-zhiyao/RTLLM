module verified_calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always@(posedge CLK or posedge RST) begin
	if (RST)
		Secs <= 0;
	else if (Secs == 59)
		Secs <= 0;
	else
		Secs <= Secs + 1;
end

always@(posedge CLK or posedge RST) begin
	if (RST)
		Mins <= 0;
	else if((Mins==59)&&(Secs==59))
		Mins <= 0;
	else if(Secs== 59)
		Mins <= Mins + 1;
	else
		Mins <= Mins;
end

always@(posedge CLK or posedge RST) begin
        if (RST)
                Hours <= 0;
        else if((Hours == 23)&&(Mins==59)&&(Secs==59))
                Hours <= 0;
        else if((Mins == 59)&&(Secs==59))
                Hours <= Hours + 1;
        else
                Hours <= Hours;
end

endmodule