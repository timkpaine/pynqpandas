`timescale 1ns/1ns
`include "pp_ifc.sv"
`include "pp_def.svh"
`include "pp_trans.sv"
`include "pp_env.sv"

/* the testbench */
`ifdef CC_MODELSIM
module pp_tb(pp_ifc.bench ds);
`else
program pp_tb(pp_ifc.bench ds);
`endif

    transaction t;
    testing_env v;
    /* reset vars */
    bit reset;

    /* fx op vars */
    int fxop;
    int fx1;
    int fx2;
 
    int fpop;
    real fp1;
    real fp2;


    initial begin
        t = new();
        v = new();
        v.read_config("./tb/config.txt");
     
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
            run_fxop();
            run_fpop();
        end
        $finish;
    end // initial begin


    /* RANDOMIZE
        based on system, randomize vars 
    */

    task f_randomize();
`ifdef CC_MODELSIM
        v.modelsim_randomize();
`else
        v.randomize();
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
            $display( "%t : %s", $realtime, t.check_reset( ds.cb.fpout, ds.cb.valid ) ? "Pass reset": "Fail reset" );
            $display( "%t : %s", $realtime, t.check_reset( ds.cb.fxout, ds.cb.valid ) ? "Pass reset": "Fail reset" );
            t.drive_reset();
        end 
        // t.clock_tic();
    endtask : run_reset

    task run_fxop();
        fxop = v.get_fxop();
        // drive inputs for next cycle
        if( fxop > 0 ) begin
            fx1 = v.fx1;
            fx2 = v.fx2;
            ds.cb.cmd <= fxop;
            ds.cb.in1 <= fx1;
            ds.cb.in2 <= fx2;
            case( fxop )
                FX_ADD: begin
                  $display("%t : %s + %d %d ", $realtime, "Driving fx op  ", fx1, fx2 );
                end
                FX_SUB: begin
                  $display("%t : %s - %d %d", $realtime, "Driving fx op ", fx1, fx2 );
                end
                FX_MUL: begin
                  $display("%t : %s * %d %d", $realtime, "Driving fx op ", fx1, fx2 );
                end
                FX_DIV: begin
                  $display("%t : %s / %d %d", $realtime, "Driving fx op ", fx1, fx2 );
                end
            endcase
          t.drive_fxop( fxop, fx1, fx2 );

        end else begin
            ds.cb.cmd <= NOOP;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
        end

        @(ds.cb);
        ds.cb.cmd <= NOOP;
        @(ds.cb);
      
        //golden results
        if( fxop ) begin
            case( fxop )
                FX_ADD: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fx_op( ds.cb.fxout, ds.cb.valid ) ? "Pass fx op +" : "Fail fx op +", t.fxout, ds.cb.fxout );
                end
                FX_SUB: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fx_op( ds.cb.fxout, ds.cb.valid ) ? "Pass fx op -" : "Fail fx op -", t.fxout, ds.cb.fxout );
                end
                FX_MUL: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fx_op( ds.cb.fxout, ds.cb.valid ) ? "Pass fx op *" : "Fail fx op *", t.fxout, ds.cb.fxout );
                end
                FX_DIV: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fx_op( ds.cb.fxout, ds.cb.valid ) ? "Pass fx op /" : "Fail fx op /", t.fxout, ds.cb.fxout );
                end
            endcase
        end else begin
          $display( "%t : %s %d %d", $realtime, t.check_noop( ds.cb.fxout, ds.cb.valid ) ? "Pass noop" : "Fail noop", t.fxout, ds.cb.fxout );
        end
        // t.clock_tic();
    endtask : run_fxop

    task run_fpop();
        fpop = v.get_fpop();
        // drive inputs for next cycle
        if( fpop > 0 ) begin
            fp1 = v.fp1;
            fp2 = v.fp2;
            ds.cb.cmd <= fpop;
            ds.cb.in1 <= fp1;
            ds.cb.in2 <= fp2;
            case( fpop )
                FP_ADD: begin
                  $display("%t : %s + %d %d ", $realtime, "Driving fp op  ", fp1, fp2 );
                end
                FP_SUB: begin
                  $display("%t : %s - %d %d", $realtime, "Driving fp op ", fp1, fp2 );
                end
                FP_MUL: begin
                  $display("%t : %s * %d %d", $realtime, "Driving fp op ", fp1, fp2 );
                end
                FP_DIV: begin
                  $display("%t : %s / %d %d", $realtime, "Driving fp op ", fp1, fp2 );
                end
            endcase
          t.drive_fpop( fpop, fp1, fp2 );

        end else begin
            ds.cb.cmd <= NOOP;
            ds.cb.in1 <= 'b0;
            ds.cb.in2 <= 'b0;
        end

        @(ds.cb);
        ds.cb.cmd <= NOOP;
        @(ds.cb);
      
        //golden results
        if( fpop ) begin
            case( fpop )
                FP_ADD: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fp_op( ds.cb.fpout, ds.cb.valid ) ? "Pass fp op +" : "Fail fp op +", t.fpout, ds.cb.fpout );
                end
                FP_SUB: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fp_op( ds.cb.fpout, ds.cb.valid ) ? "Pass fp op -" : "Fail fp op -", t.fpout, ds.cb.fpout );
                end
                FP_MUL: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fp_op( ds.cb.fpout, ds.cb.valid ) ? "Pass fp op *" : "Fail fp op *", t.fpout, ds.cb.fpout );
                end
                FP_DIV: begin
                    $display( "%t : %s %d %d", $realtime, t.check_fp_op( ds.cb.fpout, ds.cb.valid ) ? "Pass fp op /" : "Fail fp op /", t.fpout, ds.cb.fpout );
                end
            endcase
        end else begin
          $display( "%t : %s %d %d", $realtime, t.check_noop( ds.cb.fpout, ds.cb.valid ) ? "Pass noop" : "Fail noop", t.fpout, ds.cb.fpout );
        end
        // t.clock_tic();
    endtask : run_fpop





`ifdef CC_MODELSIM
endmodule // ffpp_tb
`else
endprogram //ffpp_tb
`endif
