`timescale 1ns/1ns

interface ff_ifc #(parameter SIZE=1)(input bit clk);
	logic [SIZE-1:0] data_i;
	logic [SIZE-1:0] data_o;
	logic reset;

	// note that the outputs and inputs are reversed from the dut
	clocking cb @(posedge clk);
		output    data_i;
		output    reset;
		input     data_o;
	endclocking

	modport bench (clocking cb);

	modport dut (
		input	clk,
		input	data_i,
		input	reset,
		output	data_o
	);
endinterface
