#ifndef DUT
#define DUT

class Dut {
    Dut() : reset(false), valid(false), out(0) {};
    ~Dut(){};

private:
    bool reset;
    bool valid;
    int out;
};

#endif