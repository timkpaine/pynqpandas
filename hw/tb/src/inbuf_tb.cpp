#include <iostream>
using namespace std;

#include "Vinbuf.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "inbuf.h"

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);

    // init top verilog instance
    Vinbuf dut;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC tr;
    dut.trace(&tr, 99);
    tr.open("dut.vcd");

    // init CPP model
    Inbuf model;

    cout << "Running initialization" << endl;
    flush(model, dut, tr);
    tr.close();

    cout << "Finished TB" << endl;
    exit(0);
}
