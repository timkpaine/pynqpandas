`timescale 1ns/1ns
`ifndef TOP
`define TOP
`include "wrapper.sv"
`include "ifc.sv"
`include "tb.sv"

module top;
   // clock generator
   bit clk = 1;
   always #5 clk = ~clk;

   // command to generate the VCD dump file that you open with DVE
   // initial $vcdpluson;

    ifc IFC(clk); // instantiate the interface file
    wrapper dut (IFC.dut); 
    tb bench (IFC.bench);
endmodule
`endif
