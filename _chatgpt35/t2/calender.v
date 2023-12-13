module calendar (
  input CLK,
  input RST,
  output reg [5:0] Hours,
  output reg [5:0] Mins,
  output reg [5:0] Secs
);

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Secs <= 6'b0;
    end else if (Secs == 6'b111111) begin
      Secs <= 6'b0;
    end else begin
      Secs <= Secs + 1;
    end
  end

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Mins <= 6'b0;
    end else if (Secs == 6'b111111 && Mins == 6'b111111) begin
      Mins <= 6'b0;
    end else if (Secs == 6'b111111) begin
      Mins <= Mins + 1;
    end
  end

  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Hours <= 6'b0;
    end else if (Secs == 6'b111111 && Mins == 6'b111111 && Hours == 6'b111111) begin
      Hours <= 6'b0;
    end else if (Secs == 6'b111111 && Mins == 6'b111111) begin
      Hours <= Hours + 1;
    end
  end

endmodule