#include "inbuf.h"
#include <cassert>

void Inbuf::eval(){
    if (!cstop && rvalid){
        ireg = 0;
        rvalid = false;
    } else if (cstop && !rvalid){
        ireg = idata;
        rvalid = true;
    }
    istop = rvalid;
    cdata = istop ? ireg : idata;
    cvalid = istop ? rvalid : ivalid;
}

void Inbuf::check_reset(int o){
    assert(true);
}

bool flush(Inbuf& model, Vinbuf& dut, VerilatedVcdC& tr){
    // initialize simulation inputs
    
    //clk=1
    dut.clk = 1;
    model.clk = 1;
    
    for (int i=0; i<10; i++) {
        // dump variables into VCD file and toggle clock
        for (int clk=0; clk<2; clk++) {
            tr.dump(2*i+clk);

            // invert clock
            dut.clk = !dut.clk;
            model.clk = !model.clk;

            // clock edge
            dut.eval();
            model.eval();
        }
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }
    return true;
}
