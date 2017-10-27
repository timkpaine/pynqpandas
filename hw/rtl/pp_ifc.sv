`timescale 1ns/1ns
`include "pp_constants.svh"

/* no iverilog support for modports or clocking */
interface  pp_ifc
(
    input bit clk
);

logic [2**CMD_SIZE_LOG2-1:0] cmd;
logic reset;
logic enable;
logic valid;


clocking cb @(posedge clk);
    output reset, enable, cmd;
    input valid;
endclocking

modport bench(
    clocking cb
);

modport dut(
    input clk, reset, enable, cmd,
    output valid
);
endinterface


