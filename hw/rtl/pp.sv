`timescale 1ns/1ns
`include "pp_constants.svh"

module pp #(parameter NOOP=4'b0000)
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
  end else begin
    case (d.cmd)
      NOOP : begin
          d.valid <= 'b0;
      end
      default: begin
          assert( 0 ) else $error("Fail-OPCODE");
      end
    endcase
  end
end

endmodule

