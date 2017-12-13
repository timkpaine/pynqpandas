#ifndef RELAY 
#define RELAY
#include <iostream>
using namespace std;
#include "Vrelay.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

class Relay{
public:
    Relay()
     : reset(false),
       enable(false),
       clk(false),
       in(0),
       valid(false),
       out(0) {};
    ~Relay(){};

    void eval();
    void check_reset(int out);

    // ins
    bool reset;
    bool enable;
    bool clk;
    int in;

    // outs
    bool valid;
    int out;
};

bool flush(Relay&, Vrelay&, VerilatedVcdC&);

#endif
