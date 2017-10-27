module equality_checker #(
	parameter DATA_WIDTH = 5,
	parameter NUM_COMP = 32
)
(
	inp_i,
	valid_i, /* validity of inputs */
	data_i,
	out_o
);

input [2**DATA_WIDTH-1:0] inp_i [NUM_COMP];
input valid_i [NUM_COMP];
input [2**DATA_WIDTH-1:0] data_i;
output [NUM_COMP] out_o;

logic [NUM_COMP] out;

assign out_o = out;

always_comb begin
	for (int iter = 0; iter < NUM_COMP; ++iter) begin
		out[iter] = ((inp_i[iter] == data_i) & valid_i[iter]);
	end
end

endmodule
