`timescale 1ns/1ns
`ifndef OPS
`define OPS
`include "def.svh"
`include "env.sv"
`include "trans.sv"
`include "ifc.sv"

`ifdef CC_VERILATOR
`define CLK #10
`else
`define CLK obj.clock()
`endif

class operations;
    logic op;
    logic reset;

    task flush(ref logic rst, ref logic signed [NUM_SIZE-1:0] in1, ref logic signed [NUM_SIZE-1:0] in2, ref logic [2**CMD_SIZE_LOG2-1:0] cmd);
        // initial reset
        rst = 1'b1;
        in1 = 'b0;
        in2 = 'b0;
        cmd = 'b0;
    endtask : flush

    task run_reset(ref testing_env v, ref transaction t, ref logic rst, ref logic out);
        reset = v.get_reset();
        
        // drive inputs for next cycle
        if(reset) begin
            rst = 1'b1;
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin
            rst = 1'b0;
        end
    endtask : run_reset

    task check_reset(ref testing_env v, ref transaction t, ref logic rst, ref logic out);
        //golden results
        if( reset ) begin
            $display( "%t : %s", $realtime, t.check_reset( out ) ? "Pass-reset":"Fail-reset" );
            t.drive_reset();
        end else begin
            $display( "%t : %s", $realtime, t.check_not_reset( out ) ? "Pass-not-reset" : "Fail-not-reset" );
        end
        // t.clock_tic();
    endtask : check_reset

    task run_op(ref testing_env v, ref transaction t, ref logic cmd, ref logic in1, ref logic in2, ref logic out);
        op = v.get_op();

        // drive inputs for next cycle
        if( op > 0 ) begin
            cmd = op;
            in1 = v.in1;
            in2 = v.in2;
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
            cmd = NOOP;
            in1 = 'b0;
            in2 = 'b0;
        end
    endtask : run_op

    task check_op(ref testing_env v, ref transaction t, ref logic cmd, ref logic in1, ref logic in2, ref logic out);
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
    endtask : check_op

endclass

`endif
