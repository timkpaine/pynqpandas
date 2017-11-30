`timescale 1ns/1ns
`ifndef WRAPPER
`define WRAPPER
`include "def.svh"
`include "ifc.sv"
`include "dut.sv"

module wrapper #()
(
    ifc.dut d
);

dut dut(.clk(d.clk),
      .reset(d.reset),
      .in1(d.in1),
      .in2(d.in2),
      .cmd(d.cmd),
      .out(d.out)
);

endmodule
`endif
