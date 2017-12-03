#include <iostream>
using namespace std;

#include "functions.h"
#include "dut.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"



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
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }
    return true;
}
