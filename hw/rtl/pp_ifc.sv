`timescale 1ns/1ns
`include "pp_constants.svh"

/* no iverilog support for modports or clocking */
interface  pp_ifc
(
    input bit clk
);

logic reset;
logic enable;
logic valid;


clocking cb @(posedge clk);
    output reset, enable, cmd, in1, in2;
    input fpout, fxout, valid;
endclocking

modport bench(
    clocking cb
);

modport dut(
    input clk, reset, enable,
    input in1, in2, cmd,
    output fpout, fxout, valid
);
endinterface


