module mmio (
  input         ha_pclock,     // Main clock

  input         ha_mmval,      // A valid MMIO is present
  input         ha_mmcfg,      // MMIO is AFU descriptor space access
  input         ha_mmrnw,      // 1 = read, 0 = write
  input         ha_mmdw,       // 1 = doubleword, 0 = word
  input  [0:23] ha_mmad,       // mmio address
  input         ha_mmadpar,    // mmio address parity
  input  [0:63] ha_mmdata,     // Write data
  input         ha_mmdatapar,  // Write data parity
  output reg    ah_mmack,      // Write is complete or Read is valid
  output reg [0:63] ah_mmdata, // Read data
  output reg    ah_mmdatapar); // Read data parity

  // Handle MMIO AFU requests
  always @ (posedge ha_pclock)
  begin
    if(ha_mmval & ha_mmcfg & ha_mmrnw)
    begin
      $monitor("AFU decriptor request");
      case(ha_mmad)
        'h0: begin
          ah_mmack <= 1;
          ah_mmdata <= 'h0000000100010010;
        end
        'h8: begin
          ah_mmack <= 1;
          ah_mmdata <= 'h0000000000000001;
        end
        'hA: begin
          ah_mmack <= 1;
          ah_mmdata <= 'h0000000000000100;
        end
        'hE: begin
          ah_mmack <= 1;
          ah_mmdata <= 'h0100000000000000;
        end
        default: begin
          ah_mmack <= 1;
          ah_mmdata <= 'h0000000000000000;
        end
      endcase
    end else begin
      ah_mmack <= 0;
      ah_mmdata <= 0;
    end
    // Handle parity bit
    ah_mmdatapar <= ^ah_mmdata;
  end

endmodule
