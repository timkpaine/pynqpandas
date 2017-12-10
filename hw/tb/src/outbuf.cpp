#include "outbuf.h"
#include <cassert>

void Outbuf::eval(){
    cstop = ovalid && ostop;
    if(!cstop){
        odata = cdata;
        ovalid = cvalid;
    }
}

void Outbuf::check_reset(int o){
    assert(true);
}

bool flush(Outbuf& model, Voutbuf& dut, VerilatedVcdC& tr){
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
