`timescale 1ns/1ns
`include "pp_constants.svh"

/* no iverilog support for modports or clocking */
`ifdef CC_modelsim
interface  pp_ifc
`endif
(
    input bit clk
);

logic [2**CMD_SIZE_LOG2-1:0] cmd;
logic reset;
logic enable;
logic valid;
    

clocking cb @(posedge clk);
    output reset, enable, cmd, in1, in2;
    input valid;
endclocking

modport bench(
    clocking cb
);

modport dut(
    input clk, reset, enable, cmd, in1, in2,
    output valid
);
endinterface


