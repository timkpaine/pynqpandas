#ifndef __FUNCTIONS__
#define __FUNCTIONS__

#include "dut.h"
#include "Vdut.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

bool flush(Dut& model, Vdut& top, VerilatedVcdC& tfp);
bool reset(Dut& model, Vdut& top, VerilatedVcdC& tfp);

#endif