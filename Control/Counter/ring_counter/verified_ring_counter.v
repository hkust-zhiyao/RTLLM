module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);


reg [7:0] state;

// State initialization
always @ (posedge clk or posedge reset)
begin
    if (reset)
        state <= 8'b0000_0001; 
    else
        state <= {state[6:0], state[7]}; 
end

assign out = state;

endmodule


