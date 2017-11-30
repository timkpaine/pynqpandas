`timescale 1ns/1ns
`include "pp_def.svh"

module pp #()
(
    pp_ifc.dut d
);

  logic test;
  logic signed [NUM_SIZE-1: 0] in1;
  logic signed [NUM_SIZE-1: 0] in2;
  assign in1 = d.in1;
  assign in2 = d.in2;
  
  always_ff @(posedge d.clk) begin
    if(d.reset) begin
        d.out <= 1'b0;
        d.out1 <= 'b0;
        test <= 1'b1;
    end else begin
      d.out <= 1'b1;
      test <= 1'b0;
      case (d.cmd)
        NOOP : begin
`ifdef DEBUG
          $display("OP +");
`endif
          d.out1 <= in1 + in2;
        end
        default: begin
           $display("Fail-OPCODE");
        end
      endcase
    end
  end


endmodule
