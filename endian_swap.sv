module endian_swap (
  input clock,
  input [0:63] in,
  output reg [0:63] out);

  always @ (posedge clock)
    out <= {in[56:63], in[48:55], in[40:47], in[32:39],
            in[24:31], in[16:23], in[8:15],  in[0:7]};
endmodule
