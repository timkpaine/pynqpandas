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
    Vdut dut;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC tr;
    dut.trace(&tr, 99);
    tr.open("dut.vcd");

    // init CPP model
    Dut model;

    cout << "Running initialization" << endl;
    flush(model, dut, tr);
    tr.close();

    cout << "Finished TB" << endl;
    exit(0);
}
