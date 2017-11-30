`timescale 1ns/1ns
`include "def.svh"

module dut #()
(
    input clk, reset,
    input in1, in2, cmd,
    output out
);

  logic signed [NUM_SIZE-1: 0] in1;
  logic signed [NUM_SIZE-1: 0] in2;
  logic clk, reset;
  logic [2**CMD_SIZE_LOG2-1:0] cmd;
  logic signed [NUM_SIZE-1: 0] out;
  
  always_ff @(posedge clk) begin
    if(reset) begin
        out <= 'b0;
    end else begin
      out <= 'b0;
      case (cmd)
        NOOP : begin
`ifdef DEBUG
          $display("NOOP");
`endif
          out <= in1 + in2;
        end
        default: begin
           $display("Fail-OPCODE");
        end
      endcase
    end
  end


endmodule
