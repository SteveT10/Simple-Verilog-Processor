module ControlUnit(Clk, Reset, ALU_s0, D_Addr, D_Wr, IR_Out, nextState, outState, 	
		   PC_Out, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, RF_W_en, RF_s);

		input Clk, Reset;
		output logic [15:0] IR_Out;
		output logic [7:0] D_Addr;
		output logic [6:0] PC_Out;
		output logic [3:0] nextState, outState, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
		output logic [2:0] ALU_s0;
		output logic D_Wr, RF_W_en, RF_s;
	
		wire [15:0] q;
		wire PCClr, PCUp, IRLd;

		InstructionMemory ROM(.address(PC_Out), .clock(Clk), .q(q));
		IR instrucReg(.Clk(Clk), .inData(q), .outData(IR_Out), .Id(IRLd));
		FSM controller(.IR(IR_Out),
			        .PC_clr(PCClr),
				.IR_Id(IRLd),
				.PC_up(PCUp),
				.D_addr(D_Addr),
				.D_wr(D_Wr),
				.RF_s(RF_s),
				.RF_W_addr(RF_W_Addr),
				.RF_W_en(RF_W_en),
				.RF_Ra_addr(RF_Ra_Addr),
				.RF_Rb_addr(RF_Rb_Addr),
				.ALU_s0(ALU_s0),
				.outputCurrentState(outState),
				.outputNextState(nextState),
				.clk(Clk));
		PC counter(.Clk(Clk), .Clr(PCClr), .Up(PCUp), .Addr(PC_Out));
		
	
		
endmodule

`timescale 1ns/1ns
module ControlUnit_tb;
	logic Clk, Reset;
	wire D_Wr, RF_W_en, RF_s;
	wire [15:0] IR_Out;
	wire [7:0] D_Addr;
	wire [6:0] PC_Out;
	wire [3:0] nextState, outState, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
	wire [2:0] ALU_s0;

	ControlUnit DUT(.Clk(Clk), .Reset(Reset), .ALU_s0(ALU_s0), .D_Addr(D_Addr), .D_Wr(D_Wr), .IR_Out(IR_Out), 
			.nextState(nextState), .outState(outState), .PC_Out(PC_Out), .RF_Ra_Addr(RF_Ra_Addr), 
			.RF_Rb_Addr(RF_Rb_Addr), .RF_W_Addr(RF_W_Addr), .RF_W_en(RF_W_en), .RF_s(RF_s));
	always begin
		Clk = 0; #10;
		Clk = 1; #10;
	end

	initial begin
		Reset = 1; #20;
		Reset = 0; #20;
		#5000;
		$stop;
	end

endmodule







