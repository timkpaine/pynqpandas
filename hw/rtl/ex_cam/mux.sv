module mux #(
	parameter SELECT_WIDTH = 5,
	parameter DATA_WIDTH = 5
)
(
	inp_i,
	selector_i,
	out_o
);

input [2**DATA_WIDTH-1:0] inp_i [2**SELECT_WIDTH-1:0];
input [SELECT_WIDTH-1:0] selector_i;
output [2**DATA_WIDTH-1:0] out_o;

logic [2**DATA_WIDTH-1:0] out;

assign out_o = out;

always_comb begin
	case (selector_i)
		5'd00: out = inp_i[0];
		5'd01: out = inp_i[1];
		5'd02: out = inp_i[2];
		5'd03: out = inp_i[3];
		5'd04: out = inp_i[4];
		5'd05: out = inp_i[5];
		5'd06: out = inp_i[6];
		5'd07: out = inp_i[7];
		5'd08: out = inp_i[8];
		5'd09: out = inp_i[9];
		5'd10: out = inp_i[10];
		5'd11: out = inp_i[11];
		5'd12: out = inp_i[12];
		5'd13: out = inp_i[13];
		5'd14: out = inp_i[14];
		5'd15: out = inp_i[15];
		5'd16: out = inp_i[16];
		5'd17: out = inp_i[17];
		5'd18: out = inp_i[18];
		5'd19: out = inp_i[19];
		5'd20: out = inp_i[20];
		5'd21: out = inp_i[21];
		5'd22: out = inp_i[22];
		5'd23: out = inp_i[23];
		5'd24: out = inp_i[24];
		5'd25: out = inp_i[25];
		5'd26: out = inp_i[26];
		5'd27: out = inp_i[27];
		5'd28: out = inp_i[28];
		5'd29: out = inp_i[29];
		5'd30: out = inp_i[30];
		5'd31: out = inp_i[31];
	endcase
end
endmodule
