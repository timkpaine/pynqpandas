`timescale 1ns/1ns

interface cam_ifc #(
	parameter ARRAY_WIDTH_LOG2 = 5,
	parameter ARRAY_SIZE_LOG2 = 5
)
(
	input bit clk
);

	logic reset;
	logic read_i;
	logic [ARRAY_WIDTH_LOG2 - 1:0] read_index_i;
	
	logic write_i;
	logic [ARRAY_WIDTH_LOG2 - 1:0] write_index_i;
	logic [2**ARRAY_WIDTH_LOG2 - 1:0] write_data_i;
	
	logic search_i;
	logic [2**ARRAY_WIDTH_LOG2 - 1:0] search_data_i;
	
	logic read_valid_o;
	logic [2**ARRAY_WIDTH_LOG2 - 1:0] read_value_o;
	
	logic search_valid_o;
	logic [ARRAY_WIDTH_LOG2 - 1:0] search_index_o;
	
	
	// note that the outputs and inputs are reversed from the dut
	clocking cb @(posedge clk);
		output reset, read_i, write_i, search_i,
		read_index_i, write_index_i, write_data_i,
		search_data_i;
		input read_valid_o, search_valid_o,
		read_value_o, search_index_o;
	endclocking
	
	modport bench (clocking cb);
	
	modport dut (
		input clk,
		input reset, read_i, write_i, search_i,
		read_index_i, write_index_i, write_data_i,
		search_data_i,
		output read_valid_o, search_valid_o,
		read_value_o, search_index_o
	);
endinterface
