`timescale 1ns/1ns
`ifndef TB
`define TB
`include "def.svh"
`include "env.sv"
`include "trans.sv"
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
     
        repeat(10) begin
            // initial reset
            reset <= 1'b1;
            in1 <= 'b0;
            in2 <= 'b0;
            cmd <= 'b0;
            //@(ds.cb);
        end // end repeat

        $finish;
    end // initial begin

endmodule //tb
`endif
