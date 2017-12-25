#ifndef OUTBUF
#define OUTBUF
#include <iostream>
using namespace std;
#include "Voutbuf.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

class Outbuf {
public:
    Outbuf()
     : reset(false),
       clk(false),
       cstop(false),
       cdata(0),
       cvalid(false),
       odata(0),
       ovalid(false) {};
    ~Outbuf(){};

    void eval();
    void check_reset(int out);

    bool reset;

    // ins
    bool clk;
    int cdata;
    bool cvalid;
    bool ostop;

    // outs
    bool cstop;
    int odata;
    bool ovalid;
};

bool flush(Outbuf&, Voutbuf&, VerilatedVcdC&);
bool test_flow(Outbuf&, Voutbuf&, VerilatedVcdC&);

#endif
