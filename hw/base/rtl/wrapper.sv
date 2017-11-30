`timescale 1ns/1ns
`include "def.svh"
`include "ifc.sv"

module dut #()
(
    ifc.dut d
);

dut d(.clk(d.clk),
      .reset(d.reset),
      .in1(d.in1),
      .in2(d.in2),
      .cmd(d.cmd),
      .out(d.out)
);

endmodule
