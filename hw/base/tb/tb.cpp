#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char **argv, char **env) {
  int i;
  int clk;
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vdut* top = new Vdut;
  
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("dut.vcd");
  
  // initialize simulation inputs
  top->clk = 1;
  top->reset = 1;

  for (i=0; i<400; i++) {
    top->reset = (i < 2);
    // dump variables into VCD file and toggle clock
    for (clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
    }
  
    if (Verilated::gotFinish())  exit(0);
  }
  tfp->close();

  std::cout << "Finished TB" << std::endl;
  exit(0);

}