`timescale 1ns/1ns
`ifndef DUT
`define DUT
`include "def.svh"

module dut #()
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic signed [NUM_SIZE-1: 0] in1,
    input logic signed [NUM_SIZE-1: 0] in2,
    input logic [2**CMD_SIZE_LOG2-1:0] cmd,
    output logic valid, 
    output logic signed [NUM_SIZE-1: 0] out
);
  logic signed [NUM_SIZE-1: 0] o;
  logic v;
  assign out = o;
  assign valid = v;

  always_ff @(posedge clk) begin
    if(enable) begin
      if(reset) begin
        o <= 'b0;
        v <= 1'b0;
      end else begin
        case (cmd)
          NOOP : begin
          end
          ADD : begin
            `ifdef DEBUG
            $display("NOOP");
            `endif
            o <= in1 + in2;
          end
          default: begin
            `ifdef DEBUG
            $display("Fail-OPCODE");
            `endif
          end
        endcase
      end
    end else begin
      o <= 'b0;
      v <= 1'b0;
    end
  end


endmodule
`endif
