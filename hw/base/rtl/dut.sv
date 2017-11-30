`timescale 1ns/1ns
`ifndef DUT
`define DUT
`include "def.svh"

module dut #()
(
    input logic clk,
    input logic reset,
    input logic signed [NUM_SIZE-1: 0] in1,
    input logic signed [NUM_SIZE-1: 0] in2,
    input logic [2**CMD_SIZE_LOG2-1:0] cmd,
    output logic out
);

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
`endif
