#ifndef DUT
#define DUT
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

class Dut {
public:
    Dut()
     : reset(false),
       enable(false),
       clk(false),
       in1(0),
       in2(0),
       cmd(0),
       valid(false),
       out(0) {};
    ~Dut(){};

    void eval();
    void check_reset(int out);

    // ins
    bool reset;
    bool enable;
    bool clk;
    int in1;
    int in2;
    int cmd;

    // outs
    bool valid;
    int out;
};

bool flush(Dut& model, Vdut& top, VerilatedVcdC& tfp);
bool reset(Dut& model, Vdut& top, VerilatedVcdC& tfp);

#endif
