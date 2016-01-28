module parity_generator (
  input clock,
  input enable,
  input reset,
  input [0:63] wed,
  // Command interface
  output reg        ah_cvalid,      // Command valid
  output reg [0:7]  ah_ctag,        // Command tag
  output            ah_ctagpar,     // Command tag parity
  output reg [0:12] ah_com,         // Command code
  output            ah_compar,      // Command code parity
  output [0:2]      ah_cabt,        // Command ABT
  output reg [0:63] ah_cea,         // Command address
  output            ah_ceapar,      // Command address parity
  output [0:15]     ah_cch,         // Command context handle
  output reg [0:11] ah_csize,       // Command size
  input  [0:7]      ha_croom,       // Command room
  // Buffer interface
  input             ha_brvalid,     // Buffer Read valid
  input  [0:7]      ha_brtag,       // Buffer Read tag
  input             ha_brtagpar,    // Buffer Read tag parity
  input  [0:5]      ha_brad,        // Buffer Read address
  output [0:3]      ah_brlat,       // Buffer Read latency
  output [0:511]    ah_brdata,      // Buffer Read data
  output [0:7]      ah_brpar,       // Buffer Read parity
  input             ha_bwvalid,     // Buffer Write valid
  input  [0:7]      ha_bwtag,       // Buffer Write tag
  input             ha_bwtagpar,    // Buffer Write tag parity
  input  [0:5]      ha_bwad,        // Buffer Write address
  input  [0:511]    ha_bwdata,      // Buffer Write data
  input  [0:7]      ha_bwpar,       // Buffer Write parity
  // Response interface
  input             ha_rvalid,      // Response valid
  input  [0:7]      ha_rtag,        // Response tag
  input             ha_rtagpar,     // Response tag parity
  input  [0:7]      ha_response,    // Response
  input  [0:8]      ha_rcredits,    // Response credits
  input  [0:1]      ha_rcachestate, // Response cache state
  input  [0:12]     ha_rcachepos    // Response cache pos
  );

  reg wed_requested;
  reg wed_received;
  reg [0:63] buffer_size;
  reg [0:63] stripe1_addr;
  reg [0:63] stripe2_addr;
  reg [0:63] parity_addr;

  assign ah_cabt = 3'b000,
         ah_cch = 0,
         ah_brlat = 1,
         // Parity bits
         ah_compar = ~^ah_com,
         ah_ceapar = ~^ah_cea,
         ah_ctagpar = ~^ah_ctag;

  // Runtime logic
  always @ (posedge clock)
  begin
    // Reset logic
    if (reset) begin
      ah_cvalid <= 0;
      wed_requested <= 0;
      wed_received <= 0;
      ah_csize <= 32;
    // Running logic
    end else if(enable) begin
      if(!wed_requested) begin
        ah_com <= 12'h0A00;
        ah_ctag <= 8'b11111111;
        ah_cea <= wed;
        ah_cvalid <= 1;
        wed_requested <= 1;
      end else if (wed_requested & !wed_received & ha_bwvalid) begin
        $display("Got WED buffer");
        // Swizzle all these inputs into big-endian byte order
        buffer_size <= {ha_bwdata[48:55], ha_bwdata[56:63],
                        ha_bwdata[32:39], ha_bwdata[40:47],
                        ha_bwdata[16:23], ha_bwdata[24:31],
                        ha_bwdata[8:15], ha_bwdata[0:7]};
        stripe1_addr <= {ha_bwdata[120:127], ha_bwdata[112:119],
                         ha_bwdata[104:111], ha_bwdata[96:103],
                         ha_bwdata[88:95], ha_bwdata[80:87],
                         ha_bwdata[72:79], ha_bwdata[64:71]};
        stripe2_addr <= {ha_bwdata[184:191], ha_bwdata[176:183],
                         ha_bwdata[168:175], ha_bwdata[160:167],
                         ha_bwdata[152:159], ha_bwdata[144:151],
                         ha_bwdata[136:143], ha_bwdata[128:135]};
        parity_addr <= {ha_bwdata[248:255], ha_bwdata[240:247],
                        ha_bwdata[232:239], ha_bwdata[224:231],
                        ha_bwdata[216:223], ha_bwdata[208:215],
                        ha_bwdata[200:207], ha_bwdata[192:199]};
        wed_received <= 1;
        ah_cea <= stripe1_addr;
        ah_cvalid <= 0;
      end else begin
        ah_cvalid <= 0;
      end
    end
  end

endmodule
