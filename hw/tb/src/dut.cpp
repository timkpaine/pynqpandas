#include "dut.h"
#include <cassert>

void Dut::eval(){
    // Clock ticking
    if(enable){
        if(reset){
            out = 0;
            valid = true;
        } else{
            if(cmd == 0){
                out = out; // noop
            } else if(cmd == 1){
                out = in1 + in2;
            }
        }
    } else {
        valid = false;;
    }
}

void Dut::check_reset(int o){
    assert(out == o);
    assert(out == 0);
}
