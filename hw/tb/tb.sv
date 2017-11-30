`timescale 1ns/1ns
`ifndef TB
`define TB
`include "def.svh"
`include "env.sv"
`include "trans.sv"
`include "ops.sv"

/* the testbench */
`ifdef CC_VCS
program tb(ifc.bench ds);
`else
module tb(ifc.bench ds);
`endif

    transaction t;
    testing_env v;
    operations o;

    /* reset vars */
    bit reset;

    /* op vars */
    int op;
    int in1;
    int in2;

    

    initial begin
        t = new();
        v = new();
        o = new();

        v.read_config("./config.txt");

        repeat(10) begin
            o.flush(ds.cb.reset, ds.cb.in1, ds.cb.in2, ds.cb.cmd);
            @(ds.cb);
        end
       @(ds.cb);
        repeat(v.iter) begin
            f_randomize();
            run_reset();
            run_op();
        end
        $finish;
    end // initial begin

    /* RANDOMIZE
        based on system, randomize vars 
    */

    task f_randomize();
`ifdef CC_VCS
        v.randomize();
`else
        v.modelsim_randomize();
`endif
    endtask


    /* function for running reset tests */
    task run_reset();
        o.run_reset(v, t, ds.cb.reset, ds.cb.out);
        @(ds.cb);
        ds.cb.reset <= 1'b0;
        @(ds.cb);
        o.check_reset(v, t, ds.cb.reset, ds.cb.out);
    endtask : run_reset

    task run_op();
        o.run_op(v, t, ds.cb.cmd, ds.cb.in1, ds.cb.in2, ds.cb.out);
        @(ds.cb);
        ds.cb.cmd = NOOP;
        @(ds.cb);
    endtask : run_op

`ifdef CC_VCS
endprogram //tb
`else
endmodule //tb
`endif
`endif
