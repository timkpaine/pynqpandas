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

    bit reset;

    int op;
    int in1;
    int in2;

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
        end

        ds.cb.reset <= 1'b0;
        repeat(2) @(ds.cb);

        repeat(v.iter) begin
            f_randomize();
            run_reset();
            run_fxop();
        end
        $finish;
    end


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


    task run_reset();
        reset = v.get_reset();
        
        if(reset) begin
            ds.cb.reset <= 1'b1;
            $display("%t : %s", $realtime, "Driving Reset");
        end else begin
            ds.cb.reset <= 1'b0;
        end

        @(ds.cb);
         ds.cb.reset <= 1'b0;
        @(ds.cb);

        if( reset ) begin
            $display( "%t : %s", $realtime, t.check_reset(ds.cb.valid ) ? "Pass reset": "Fail reset" );
            $display( "%t : %s", $realtime, t.check_reset(ds.cb.valid ) ? "Pass reset": "Fail reset" );
            t.drive_reset();
        end 
    endtask : run_reset

`ifdef CC_MODELSIM
endmodule
`else
endprogram
`endif

