`timescale 1ns/1ns
`include "pp.sv"

module pp_top;

   // clock generator
   bit clk = 1;
   always #5 clk = ~clk;

   // command to generate the VCD dump file that you open with DVE
   // initial $vcdpluson;

    pp_ifc IFC(clk); // instantiate the interface file
    pp dut (IFC.dut); 
    pp_tb bench (IFC.bench);

endmodule
