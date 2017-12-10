`timescale 1ns/1ns
`ifndef RELAY 
`define RELAY
`include "def.svh"

module relay #()
(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic signed [NUM: 0] in,
    output logic valid, 
    output logic signed [NUM: 0] out,
    input logic _delay,
    output logic delay_
);
  logic signed [NUM: 0] o;
  logic v;
  logic d;
  assign out = o;
  assign valid = v;
  assign delay_ = d;

  logic holding;
  logic signed [NUM:0] hold;

  always_ff @(posedge clk) begin
    if(enable) begin
      if(reset) begin
        o <= 'b0;
        v <= 1'b0;
        d <= 1'b0;
      end else begin
          case({_delay, holding}) 
              2'b00: begin
                  o <= in;
                  v <= 1'b1;
                  d <= 1'b0;
              end
              2'b01: begin
                  o <= hold;
                  v <= 1'b1;
                  holding <= 1'b0;
                  d <= 1'b0;
              end
              2'b10: begin
                  holding <= 1'b1;
                  hold <= in;
                  d <= 1'b1;
              end
              2'b11: begin
                  holding <= 1'b1;
                  d <= 1'b1;
              end
          endcase
      end
    end else begin
      o <= 'b0;
      v <= 1'b0;
    end
  end


endmodule
`endif
