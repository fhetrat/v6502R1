module core();

reg reg_pc;
reg reg_flag;

endmodule


//decode

module prime_decoder(inst_in);

input inst_in[7:0];


wire inst_c_type[1:0];

inst_type TD0(inst_in, inst_c_type);
addr_mode AD0(inst_c_type, inst_in[4:2], , );

endmodule


module inst_type(inst_in, inst_type);

input inst_in[7:0];

output inst_type[4:0];
output branch_enable;
output branch_cond;

always @(*)
	begin
		case(inst_in)
			8'bxxx10000 : inst_type = 5'b10000; //branch
			8'b1xxx1010 : //1B op
			8'bxxx01000 : //1B op(interrupts)
			default : begin
				c_type[0] = 1;
				c_type[1] = inst_in[0];
			end 
		endcase
	end
endmodule

module addr_mode(c_type, inst_bbb, addr_uOP, inst_len);

input c_type[1:0];
input inst_bbb[2:0];

output addr_uOP[6:0];	// X Y - ACC Imm ZP ABS indirect(flag)
output inst_len[1:0];

wire b_enable;
wire b_mode;

assign b_enable = c_type[0];
assign b_mode = c_type[1];

always @(b_enable)
	begin
		case(inst_bbb)
			3'b000 : begin
				if(b_mode == 1)
					inst_len = 2'h2;
					addr_uOP = 7'b1000101; //(zp,x)
				else
					inst_len = 2'h2;
					addr_uOP = 7'b0001000; //imm
				end 
			3'b001 : begin
				inst_len = 2'h2;
				addr_uOP = 7'b0000100; //zp
				end 
			3'b010 : begin
				if(b_mode == 1)
					inst_len = 2'h2;
					addr_uOP = 7'b0001000; //imm
				else
					inst_len = 2'h2;
					addr_uOP = 7'b0010000; //acc
				end 
			3'b011 : begin
				inst_len = 2'h3;
				addr_uOP = 7'b0000010;	//abs
				end
			3'b100 : begin
				inst_len = 2'h2;
				addr_uOP = 7'b0100101;	//(zp),y
				end 
			3'b101 : begin
				inst_len = 2'h2;
				addr_uOP = 7'b1000100;	//zp,x
				end 
			3'b110 : begin
				inst_len = 2'h3;
				addr_uOP = 7'b0100010;	//abs,y
				end 
			3'b111 : begin
				inst_len = 2'h3;
				addr_uOP = 7'b1000010;	//abs,x
				end 
			default : begin
				inst_len = 2'h1;
				addr_uOP = 7'b0000000;
				end
		endcase
	end
endmodule

//execute

module branch(reg_flag, reg_pc, branch_enable, branch_cond)

input reg_flag;
input branch_enable;
input branch_cond[2:0];

reg cond_flag;

output reg reg_pc;

always@(branch_enable)
	begin
		case(branch_cond[2:1])
			2'b00 : if(branch_cond[0] == reg_flag[7]) //negative
			2'b01 : if(branch_cond[0] == reg_flag[6]) //overflow
			2'b10 : if(branch_cond[0] == reg_flag[0]) //carry
			2'b11 : if(branch_cond[0] ==)
	end 
endmodule
