`timescale 1ns/1ns
`ifndef OPS
`define OPS
`include "def.svh"
`include "env.sv"
`include "trans.sv"


`ifdef CC_VERILATOR
`define CLK #10
`else
`define CLK @(cb)
`endif

class operations;
    function flush(ref logic rst, ref logic in1, ref logic in2, ref logic cmd, ref clocking cb);
        repeat(10) begin
            // initial reset
            rst <= 1'b1;
            in1 <= 'b0;
            in2 <= 'b0;
            cmd <= 'b0;

            CLK;

        end // end repeat

        rst <= 1'b0;

        CLK;
        CLK;

    endfunction : flush

    function run_reset(ref testing_env v, ref transaction t, ref logic rst, ref logic out, ref clocking cb);
        reset = v.get_reset();
        
        // drive inputs for next cycle
        if(reset) begin
            rst <= 1'b1;
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin
            rst <= 1'b0;
        end

        CLK;
        rst <= 1'b0;
        CLK;

        //golden results
        if( reset ) begin
            $display( "%t : %s", $realtime, t.check_reset( out ) ? "Pass-reset":"Fail-reset" );
            t.drive_reset();
        end else begin
            $display( "%t : %s", $realtime, t.check_not_reset( out ) ? "Pass-not-reset" : "Fail-not-reset" );
        end
        // t.clock_tic();
    endfunction : run_reset

    task run_op(ref testing_env v, ref transaction t, ref logic cmd, ref logic in1, ref logic in2, ref logic out, ref clocking cb);
        op = v.get_op();

        // drive inputs for next cycle
        if( op > 0 ) begin
            cmd <= op;
            in1 <= v.in1;
            in2 <= v.in2;
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
            cmd <= NOOP;
            in1 <= 'b0;
            in2 <= 'b0;
        end

        CLK;
        ds.cb.cmd <= NOOP;
        CLK;
      
        //golden results
        if( op ) begin
            case( op )
                ADD: begin
                    $display( "%t : %s %d %d", $realtime, t.check_op( out ) ? "Pass-op +" : "Fail-op +", t.out, out);
                end
            endcase
        end else begin
          $display( "%t : %s %d %d", $realtime, t.check_noop( out ) ? "Pass-noop" : "Fail-noop", t.out, out);
        end
        // t.clock_tic();
    endfunction : run_op

endclass