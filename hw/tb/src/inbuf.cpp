#include "inbuf.h"
#include <cassert>

void Inbuf::eval(){
    if(reset){
        ireg = 0;
        rvalid = false;
    }
    if(!cstop && rvalid){
        ireg = 0;
        rvalid = false;
    } else if(cstop && !rvalid){
        ireg = idata;
        rvalid = true;
    }
    istop = rvalid;
    cdata = istop ? ireg : idata;
    cvalid = istop ? rvalid : ivalid;
}

void Inbuf::check_reset(int o){
    assert(cdata == 0);
    assert(cdata == o);
}

bool flush(Inbuf& model, Vinbuf& dut, VerilatedVcdC& tr){
    // initialize simulation inputs
    
    //clk=1
    dut.clk = 1;
    model.clk = 1;
    
    //reset=1
    dut.reset = 1;
    model.reset = 1;
    
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
                cout << "Asserting reset : " << 0 << " : " << dut.cdata << " " << model.cdata << endl;
                model.check_reset(dut.cdata);
            }
        }
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }
    return true;
}

bool test_flow(Inbuf& model, Vinbuf& dut, VerilatedVcdC& tr){

    //clk=1
    dut.clk = 1;
    model.clk = 1;
    
    //reset=1
    dut.reset = 1;
    model.reset = 1;
    
    for (int i=0; i<12; i++) {
        dut.reset = (i < 2);
        model.reset = (i < 2);

        // dump variables into VCD file and toggle clock
        for (int clk=0; clk<2; clk++) {
            tr.dump(2*i+clk);

            // invert clock
            dut.clk = !dut.clk;
            model.clk = !model.clk;


            if(i > 2){
                dut.ivalid = 1;
                model.ivalid = 1;

                dut.idata = random();
                model.idata = dut.idata;
                cout << "idata: " << dut.idata << endl;
            }

            if(i == 5){
                dut.ivalid = 0;
                model.ivalid = 0;

                cout << "driving ivalid=0" << endl;
            }

            if(i == 7){
                dut.cstop = 1;
                model.cstop = 1;

                cout << "driving cstop=1" << endl;
            }

            if(i > 9){
                dut.cstop = 0;
                model.cstop = 0;

                cout << "driving cstop=0" << endl;
            }

            // clock edge
            dut.eval();
            model.eval();


            if(i>2){
                cout << "Checking indata" << endl;
                cout << "dut: " << dut.cdata << "," << bool(dut.cvalid) << "\tmodel: " << model.cdata << "," << model.cvalid << "-" << model.ireg << "," << model.rvalid << endl;
            }
            if(i==5){
                cout << "Checking invalid" << endl;
                cout << dut.cdata << " " << model.cdata << endl;
            }
            if(i==7){
                cout << "Checking cstop" << endl;
                cout << dut.cdata << " " << model.cdata << endl;
            }
            if(i>9){
                cout << "Checking continue" << endl;
                cout << dut.cdata << " " << model.cdata << endl;
            }
        }
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }


    return true;
}
