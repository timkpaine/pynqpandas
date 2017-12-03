#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>
using namespace std;

bool flush(Vdut* top, VerilatedVcdC* tfp){
  // initialize simulation inputs
  top->clk = 1;
  top->reset = 1;
  top->enable = 1;

  for (int i=0; i<10; i++) {
    top->reset = (i < 2);
    // dump variables into VCD file and toggle clock
    for (int clk=0; clk<2; clk++) {
      tfp->dump (2*i+clk);
      top->clk = !top->clk;
      top->eval ();
      if(top->reset){
          cout << "Asserting reset : " << 0 << " : " << top->out << endl;
          assert(top->out == 0);
      }
    }
    if (Verilated::gotFinish())  exit(0);
  }
}


int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);

  // init top verilog instance
  Vdut* top = new Vdut;
  
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("dut.vcd");
 
  cout << "Running initialization" << endl;
  flush(top, tfp);
  tfp->close();

  cout << "Finished TB" << endl;
  exit(0);
}
