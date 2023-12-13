module calendar (
  input CLK,
  input RST,
  output reg [5:0] Hours,
  output reg [5:0] Mins,
  output reg [5:0] Secs
);
  reg [5:0] next_hours, next_mins, next_secs;

  always @(posedge CLK or posedge RST) begin
    if (RST)
      Secs <= 6'b0;
    else if (Secs == 6'b111111)
      Secs <= 6'b0;
    else
      Secs <= Secs + 1;
  end

  always @(posedge CLK or posedge RST) begin
    if (RST)
      Mins <= 6'b0;
    else if (Secs == 6'b111111 && Mins == 6'b111111)
      Mins <= 6'b0;
    else if (Secs == 6'b111111)
      Mins <= Mins + 1;
  end

  always @(posedge CLK or posedge RST) begin
    if (RST)
      Hours <= 6'b0;
    else if (Secs == 6'b111111 && Mins == 6'b111111 && Hours == 6'b111111)
      Hours <= 6'b0;
    else if (Secs == 6'b111111 && Mins == 6'b111111)
      Hours <= Hours + 1;
  end

endmodule