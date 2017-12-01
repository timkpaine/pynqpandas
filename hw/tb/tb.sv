`timescale 1ns/1ns
`ifndef TB
`define TB
`include "def.svh"
`include "env.sv"
`include "trans.sv"

/* the testbench */
`ifdef CC_VCS
`define MOD ds.cb.
program tb(ifc.bench ds);
`else
`ifdef CC_MODELSIM
`define MOD ds.cb.
module tb(ifc.bench ds);
`else 
`define MOD 
`include "dut.sv"
module tb;
`endif
`endif

    transaction t;
    testing_env v;

`ifdef CC_VIVADO
    logic clk;
    logic reset;
    logic signed [NUM_SIZE-1: 0] in1;
    logic signed [NUM_SIZE-1: 0] in2;
    logic [2**CMD_SIZE_LOG2-1:0] cmd;
    logic out;

    int op;
    dut dut(.clk(clk),
      .reset(reset),
      .in1(in1),
      .in2(in2),
      .cmd(cmd),
      .out(out)
    );

    always #5 clk = ~clk;
`else
    /* reset vars */
    bit reset;

    /* op vars */
    int op;
    int in1;
    int in2;
`endif
   
    initial begin
        t = new();
        v = new();
        v.read_config("./config.txt");
        repeat(10) begin
`ifdef CC_VIVADO
            reset = 1'b1;
            in1 = 'b0;
            in2 = 'b0;
            cmd = 'b0;
            #10;
`else
            ds.cb.reset = 1'b1;
            ds.cb.in1 = 'b0;
            ds.cb.in2 = 'b0;
            ds.cb.cmd = 'b0;
            @(ds.cb);
`endif
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
        reset = v.get_reset();
        
        // drive inputs for next cycle
        if(reset) begin
            ds.cb.reset = 1'b1;
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin
            ds.cb.reset = 1'b0;
        end
        @(ds.cb);
        ds.cb.reset <= 1'b0;
        @(ds.cb);
        //golden results
        if( reset ) begin
            $display( "%t : %s", $realtime, t.check_reset( ds.cb.out ) ? "Pass-reset":"Fail-reset" );
            t.drive_reset();
        end else begin
            $display( "%t : %s", $realtime, t.check_not_reset( ds.cb.out ) ? "Pass-not-reset" : "Fail-not-reset" );
        end
        // t.clock_tic();
    endtask : run_reset

    task run_op();
        op = v.get_op();

        // drive inputs for next cycle
        if( op > 0 ) begin
            ds.cb.cmd = op;
            ds.cb.in1 = v.in1;
            ds.cb.in2 = v.in2;
            case( op )
                ADD: begin
                  $display("%t : %s + %d %d ", $realtime, "Driving op  ", v.in1, v.in2);
                end
                NOOP: begin
                  $display("%t : %s", $realtime, "Driving noop ");
                end
            endcase
          t.drive_op( op, v.in1, v.in2 );

        end else begin
            ds.cb.cmd = NOOP;
            ds.cb.in1 = 'b0;
            ds.cb.in2 = 'b0;
        end
        @(ds.cb);
        ds.cb.cmd = NOOP;
        @(ds.cb);
        //golden results
        if( op ) begin
            case( op )
                ADD: begin
                    $display( "%t : %s %d %d", $realtime, t.check_op( ds.cb.out ) ? "Pass-op +" : "Fail-op +", t.out, ds.cb.out);
                end
            endcase
        end else begin
          $display( "%t : %s %d %d", $realtime, t.check_noop( ds.cb.out ) ? "Pass-noop" : "Fail-noop", t.out, ds.cb.out);
        end
        // t.clock_tic();
    endtask : run_op


/* the testbench */
`ifdef CC_VCS
endprogram
`else
endmodule 
`endif
`endif
