#include <iostream>
using namespace std;

#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "functions.h"
#include "dut.h"

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);

    // init top verilog instance
    Vdut* top = new Vdut;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("dut.vcd");

    cout << "Running initialization" << endl;
    flush(top, tfp);
    tfp->close();

    cout << "Finished TB" << endl;
    exit(0);
}
