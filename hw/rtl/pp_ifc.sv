`timescale 1ns/1ns
`ifndef PP_IFC
`define PP_IFC


interface  pp_ifc
(
    input bit clk
);

logic reset;
logic [2**CMD_SIZE_LOG2-1:0] cmd;
logic [NUM_SIZE-1:0] in1, in2;
logic out;
logic [NUM_SIZE-1:0] out1;

modport dut(
    input clk, reset,
    input in1, in2, cmd,
    output out, out1
);

clocking cb @(posedge clk);
    output reset, cmd, in1, in2;
    input out, out1;
endclocking

modport bench(
    clocking cb
);

endinterface
`endif