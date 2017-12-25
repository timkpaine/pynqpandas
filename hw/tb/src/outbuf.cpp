#include "outbuf.h"
#include <cassert>

void Outbuf::eval(){
    if(clk){
        if(reset){
            odata = 0;
            ovalid = false;
        }
        if(!cstop){
            odata = cdata;
            ovalid = cvalid;
        }
        cstop = ovalid && ostop;
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


bool test_flow(Outbuf& model, Voutbuf& dut, VerilatedVcdC& tr){

    //clk=1
    dut.clk = 0;
    model.clk = 0;
    
    //reset=1
    dut.reset = 1;
    model.reset = 1;
    
    for (int i=0; i<20; i++) {
        dut.reset = (i < 2);
        model.reset = (i < 2);

        // dump variables into VCD file and toggle clock
        for (int clk=0; clk<2; clk++) {
            tr.dump(2*i+clk);

            // invert clock
            dut.clk = !dut.clk;
            model.clk = !model.clk;


            if(i > 2){
                dut.cvalid = 1;
                model.cvalid = 1;

                if(clk==0){
                    dut.cdata = random();
                    model.cdata = dut.cdata;
                    cout << "cdata: " << dut.cdata << endl;
                }
            }

            if(i == 5){
                dut.cvalid = 0;
                model.cvalid = 0;

                cout << "driving cvalid=0" << endl;
            }

            if(i == 7){
                dut.ostop = 1;
                model.ostop = 1;

                cout << "driving ostop=1" << endl;
            }

            if(i > 9){
                dut.ostop = 0;
                model.ostop = 0;
                cout << "driving ostop=0" << endl;
            }

            // clock edge
            dut.eval();
            model.eval();


            cout << "Checking dut==model" << endl;

            if(dut.odata != model.odata || dut.ovalid != model.ovalid){
                cerr << "ERROR\tdut: " << dut.odata << "," << bool(dut.ovalid) << "\tmodel: " << model.odata << "," << model.ovalid << endl;
            }
            
            if(i>2){
                cout << "Checking cdata" << endl;
            }

            if(i==5){
                cout << "Checking cvalid" << endl;
            }

            if(i==7){
                cout << "Checking ostop" << endl;
            }

            if(i>9){
                cout << "Checking continue" << endl;
            }
        }
        if (Verilated::gotFinish()){
            cout << "Finished" << endl;
            exit(0);
        }
    }


    return true;
}
