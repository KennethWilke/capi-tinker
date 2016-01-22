module shift_register(
  clock,
  in,
  out);

  parameter width = 1;
  input clock;
  input [0:width-1] in;
  output reg [0:width-1] out;
  
  always @ (posedge clock) begin
    out <= in;
  end
endmodule
