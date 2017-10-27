
module register #(
	parameter SIZE = 5
)
(
	input clk,
	input reset,
	input enable,

	input logic [SIZE-1:0] data_i,
	output logic [SIZE- 1:0] data_o,
	output bit valid_o
);

ceff #(.SIZE(SIZE)) ff_inst(.*);

endmodule
