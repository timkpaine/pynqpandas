#include "dut.h"
#include <cassert>

void Dut::eval(){
    // Clock ticking
    if(enable && reset){
        out = 0;
    }
}

void Dut::check_reset(int o){
    assert(out == o);
    assert(out == 0);
}
