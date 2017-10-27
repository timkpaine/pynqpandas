`timescale 1ns/1ns
// the timescale directive tells the compiler the clock period and the
// precision that needs to be displayed in the VCD dump file

module cam_top;

   // clock generator
   bit clk = 1;
   always #5 clk = ~clk;

   // command to generate the VCD dump file that you open with DVE
   initial $vcdpluson;

   cam_ifc IFC(clk); // instantiate the interface file
   cam dut (IFC.dut); 
   cam_tb bench (IFC.bench);

endmodule
