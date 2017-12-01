`timescale 1ns/1ns
`ifndef TB
`define TB
`include "def.svh"
`include "env.sv"
`include "trans.sv"

/* the testbench */
`ifdef CC_VCS
`define CLK @(ds.cb);
program tb(ifc.bench ds);
`else
`ifdef CC_MODELSIM
`define CLK @(ds.cb);
module tb(ifc.bench ds);
`else 
`define CLK #10;
`include "dut.sv"
module tb;
`endif
`endif

    transaction t;
    testing_env v;
    int op;
    logic reset;

`ifdef CC_VIVADO
    logic clk;
    logic signed [NUM_SIZE-1: 0] in1;
    logic signed [NUM_SIZE-1: 0] in2;
    logic [2**CMD_SIZE_LOG2-1:0] cmd;
    logic out;
    logic rst;

    dut dut(.clk(clk),
      .reset(rst),
      .in1(in1),
      .in2(in2),
      .cmd(cmd),
      .out(out)
    );
    always #5 clk = ~clk;
`else
    /* op vars */
    int in1;
    int in2;
`endif
   
    initial begin
        t = new();
        v = new();
        v.read_config("./config.txt");
        repeat(10) begin
`ifdef CC_VIVADO
            reset <= 1'b1;
            in1 <= 'b0;
            in2 <= 'b0;
            cmd <= 'b0;
`else
            ds.cb.reset <= 1'b1;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
            ds.cb.cmd <= 'b0;
`endif
        `CLK
        end

        `CLK

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

`ifdef CC_VIVADO
            rst <= 1'b1;
`else 
            ds.cb.reset <= 1'b1;
`endif
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin

`ifdef CC_VIVADO
            rst <= 1'b0;
`else 
            ds.cb.reset <= 1'b0;
`endif

        end
        `CLK

`ifdef CC_VIVADO
        rst <= 1'b0;
`else 
        ds.cb.reset <= 1'b0;
`endif
        `CLK
        //golden results
        if( reset ) begin

`ifdef CC_VIVADO
            $display( "%t : %s", $realtime, t.check_reset( out ) ? "Pass-reset":"Fail-reset" );
`else 
            $display( "%t : %s", $realtime, t.check_reset( ds.cb.out ) ? "Pass-reset":"Fail-reset" );
`endif

            t.drive_reset();
        end else begin

`ifdef CC_VIVADO
            $display( "%t : %s", $realtime, t.check_not_reset(out) ? "Pass-not-reset" : "Fail-not-reset" );
`else 
            $display( "%t : %s", $realtime, t.check_not_reset(ds.cb.out) ? "Pass-not-reset" : "Fail-not-reset" );
`endif

        end
        // t.clock_tic();
    endtask : run_reset

    task run_op();
        op = v.get_op();

        // drive inputs for next cycle
        if( op > 0 ) begin

`ifdef CC_VIVADO
            cmd <= op;
            in1 <= v.in1;
            in2 <= v.in2;
`else 
            ds.cb.cmd <= op;
            ds.cb.in1 <= v.in1;
            ds.cb.in2 <= v.in2;
`endif
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

`ifdef CC_VIVADO
            cmd <= NOOP;
            in1 <= 'b0;
            in2 <= 'b0;
`else 
            ds.cb.cmd <= NOOP;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
`endif

        end
        `CLK
`ifdef CC_VIVADO
        cmd <= NOOP;
`else 
        ds.cb.cmd <= NOOP;
`endif
        `CLK
        //golden results
        if( op ) begin
            case( op )
                ADD: begin

`ifdef CC_VIVADO
                    $display( "%t : %s %d %d", $realtime, t.check_op( out ) ? "Pass-op +" : "Fail-op +", t.out, out);
`else 
                    $display( "%t : %s %d %d", $realtime, t.check_op( ds.cb.out ) ? "Pass-op +" : "Fail-op +", t.out, ds.cb.out);
`endif

                end
            endcase
        end else begin

`ifdef CC_VIVADO
          $display( "%t : %s %d %d", $realtime, t.check_noop( out ) ? "Pass-noop" : "Fail-noop", t.out, out);
`else 
          $display( "%t : %s %d %d", $realtime, t.check_noop( ds.cb.out ) ? "Pass-noop" : "Fail-noop", t.out, ds.cb.out);
`endif

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
