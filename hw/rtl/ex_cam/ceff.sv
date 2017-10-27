
module ceff #(
	parameter SIZE = 1
)
(
	input clk,
	input reset,
	input enable,

	input logic [SIZE-1:0] data_i,
	output logic [SIZE- 1:0] data_o,
	output bit valid_o
);

reg [SIZE-1:0] data;
bit valid;

assign data_o = data;
assign valid_o = valid;

always_ff @(posedge clk) begin
	if(reset) begin
		data <= 'b0;
		valid <= 'b0;
	end
	else begin
		if (enable) begin
			data <= data_i;
			valid <= 'b1;
		end
	end
end

endmodule
