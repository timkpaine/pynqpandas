`timescale 1ns/1ns
`ifndef IFC
`define IFC
`include "def.svh"
interface  ifc
(
    input bit clk
);

logic reset;
logic enable;
logic valid;
logic [2**CMD_SIZE_LOG2-1:0] cmd;
logic [NUM_SIZE-1:0] in1, in2;
logic [NUM_SIZE-1:0] out;

modport dut (
    input clk, reset, enable,
    input in1, in2, cmd,
    output out, valid
);


clocking cb @(posedge clk);
    output reset, enable, cmd, in1, in2;
    input out, valid;
endclocking

modport bench (
    clocking cb
);

endinterface
`endif
