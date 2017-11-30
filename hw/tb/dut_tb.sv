`timescale 1ns/1ns
`ifndef TB
`define TB
`include "def.svh"
`include "env.sv"
`include "trans.sv"
`include "ops.sv"
`include "dut.sv"

module dut_tb;

    transaction t;
    testing_env v;

    logic clk;
    logic reset;
    logic signed [NUM_SIZE-1: 0] in1;
    logic signed [NUM_SIZE-1: 0] in2;
    logic [2**CMD_SIZE_LOG2-1:0] cmd;
    logic out;

    dut dut(.clk(clk),
      .reset(reset),
      .in1(in1),
      .in2(in2),
      .cmd(cmd),
      .out(out)
    );

    always #5 clk = ~clk;
   
    initial begin
        t = new();
        v = new();
        v.read_config("./config.txt");

        o.flush(dut.reset, dut.in1, dut.in2, dut.cmd);

        v.modelsim_randomize();
        run_reset();
        run_op();
        $finish;
    end // initial begin

    /* function for running reset tests */
    task run_reset();
        o.run_reset(v, t, dut.reset, dut.out);
    endtask : run_reset

    task run_op();
        o.run_op(v, t, dut.cmd, dut.in1, dut.in2, dut.out)
    endtask : run_op

endmodule //tb
`endif
