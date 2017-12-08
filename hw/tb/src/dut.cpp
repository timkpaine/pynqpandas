#include "dut.h"
#include <cassert>
#include <iostream>
using namespace std;

void Dut::eval(){
    // Clock ticking
    if(enable){
        if(reset){
            out = 0;
            valid = true;
        } else{
            if(cmd == 0){
                // noop
            } else if(cmd == 1){
                out = in1 + in2;
            }
        }
    } else {
        valid = false;
    }
}

void Dut::check_reset(int o){
    assert(out == o);
    assert(out == 0);
}

bool flush(Dut& model, Vdut& dut, VerilatedVcdC& tr){
    // initialize simulation inputs
    
    //clk=1
    dut.clk = 1;
    model.clk = 1;
    
    //reset=1
    dut.reset = 1;
    model.reset = 1;
    
    //enable=1
    dut.enable = 1;
    model.enable = 1;


    for (int i=0; i<10; i++) {
        dut.reset = (i < 2);
        model.reset = (i < 2);

        // dump variables into VCD file and toggle clock
        for (int clk=0; clk<2; clk++) {
            tr.dump(2*i+clk);

            // invert clock
            dut.clk = !dut.clk;
            model.clk = !model.clk;

            // clock edge
            dut.eval();
            model.eval();

            if(dut.reset){
                cout << "Asserting reset : " << 0 << " : " << dut.out << " " << model.out << endl;
                model.check_reset(dut.out);
            }

        }
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }
    return true;
}
