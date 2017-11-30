`timescale 1ns/1ns
`ifndef OPS
`define OPS
`include "def.svh"
`include "env.sv"
`include "trans.sv"

class operations;
    function flush(ref logic rst, ref logic in1, logic in2, logic cmd, clocking cb=NULL);
    endfunction : flush

    function run_reset();
    endfunction : run_reset

    task run_op();
    endfunction : run_op



`ifdef CC_VCS
endprogram //tb
`else
endmodule //tb
`endif
`endif

        repeat(10) begin
            // initial reset
            ds.cb.reset <= 1'b1;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
            ds.cb.cmd <= 'b0;
            @(ds.cb);
        end // end repeat

        ds.cb.reset <= 1'b0;
        repeat(2) @(ds.cb); // flush


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
            ds.cb.reset <= 1'b1;
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin
            ds.cb.reset <= 1'b0;
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
            in1 = v.in1;
            in2 = v.in2;
            ds.cb.cmd <= op;
            ds.cb.in1 <= in1;
            ds.cb.in2 <= in2;
            case( op )
                ADD: begin
                  $display("%t : %s + %d %d ", $realtime, "Driving op  ", in1, in2 );
                end
                NOOP: begin
                  $display("%t : %s", $realtime, "Driving noop ");
                end
            endcase
          t.drive_op( op, in1, in2 );

        end else begin
            ds.cb.cmd <= NOOP;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
        end

        @(ds.cb);
        ds.cb.cmd <= NOOP;
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



`ifdef CC_VCS
endprogram //tb
`else
endmodule //tb
`endif
`endif