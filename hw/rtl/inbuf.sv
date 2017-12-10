// thanks to Bingyi/Ken/Martha/Stephen
`timescale 1ns/1ns
`ifndef INBUF
`define INBUF
`include "def.svh"

module inbuf #()
(
    input logic clk,
    input logic signed[NUM-1:0] idata,
    input logic ivalid,
    output logic istop,
    output logic signed [NUM-1:0] cdata,
    output logic cvalid,
    input logic cstop
);

logic [NUM-1:0] ireg = 'bx; // Empty
logic rvalid = 1'b0;      // ireg is full

assign istop = rvalid;               // Stop if buffering
assign cdata = istop ? ireg : idata; // Send buffered
assign cvalid = istop ? rvalid : ivalid;

always_ff @(posedge clk) begin
    if (!cstop && rvalid) begin // Will core consume?
        ireg <= 'bx;              // Yes: empty buffer
        rvalid <= 1'b0;
    end else if (cstop && !rvalid) begin   // Core stop, empty?
        ireg <= idata;                     // Yes: load buffer
        rvalid <= ivalid;
    end
end

endmodule
`endif