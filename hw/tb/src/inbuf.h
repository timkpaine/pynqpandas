#ifndef INBUF
#define INBUF
#include <iostream>
using namespace std;
#include "Vinbuf.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

class Inbuf {
public:
    Inbuf()
     : reset(false),
       clk(false),
       istop(false),
       cstop(false),
       idata(0),
       ivalid(false),
       cdata(0),
       cvalid(false),
       ireg(0),
       ireg_n(0),
       rvalid(false),
       rvalid_n(false) {};
    ~Inbuf(){};

    void eval();
    void check_reset(int out);

    bool reset;

    // ins
    bool clk;
    int idata;
    bool ivalid;
    bool cstop;

    // outs
    bool istop;
    int cdata;
    bool cvalid;

    //members
    int ireg;
    int ireg_n;
    bool rvalid;
    bool rvalid_n;
};

bool flush(Inbuf&, Vinbuf&, VerilatedVcdC&);
bool test_flow(Inbuf&, Vinbuf&, VerilatedVcdC&);

#endif
