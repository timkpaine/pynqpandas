// thanks to Bingyi/Ken/Martha/Stephen
`timescale 1ns/1ns
`ifndef OUTBUF
`define OUTBUF
`include "def.svh"

module outbuf #()
(
    input logic clk, 
    input logic reset, 
    input logic signed [NUM:0] cdata,
    input logic cvalid,
    output logic cstop, 
    output logic signed [NUM:0] odata,
    output logic ovalid,
    input ostop
);

initial odata = 'bx; // Empty
initial ovalid = 1'b0;

// Stop the core when buffer full and output not ready
assign cstop = ovalid && ostop;

always_ff @(posedge clk) begin
    if(reset) begin
        odata <= 'bx;
        ovalid <= 1'b0;
    end
    if(!cstop) begin // Can we accept more data?
        odata <= cdata; // Yes: load the buffer
        ovalid <= cvalid;
    end
end
endmodule

`endif
