module Top
(
    input clk,
    input areset // Asynchronous reset signal
);

// Internal wires and registers
wire [31:0] PC, SrcA, SrcB, ALUResult, ImmExt, Inst, WriteData, ReadData, Result;
wire [2:0] AluControl;
wire [1:0] ImmSrc;
wire zeroFlag, signFlag, PCSrc, ALUSrc, RegWrite, ResultSrc, MemWrite, load;
 
Program_Counter top_PC
(
    .clk(clk),
    .areset(areset),
    .load(1'b1),
    .PCSrc(PCSrc),
    .ImmExt(ImmExt),
    .PC(PC)
);

// Instantiate the Instruction Memory
Instruction_Memory top_inst_mem
(
    .A(PC),
    .RD(Inst)
);

// Instantiate the Control Unit
Control_Unit top_control_unit
(
    .opcode(Inst[6:0]),
    .func7(Inst[30]),
    .func3(Inst[14:12]),
    .Zero_Flag(zeroFlag),
    .Sign_Flag(signFlag),
    .ALUControl(AluControl),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc)
);

// Instantiate the Register File
 rf_module top_register_file 
 ( 
    .clk(clk),
    .rst_n(areset),
    .WE3(RegWrite),
    .A1(Inst[19:15]),
    .A2(Inst[24:20]),
    .A3(Inst[11:7]),
    .WD3(Result),
    .RD1(SrcA),
    .RD2(WriteData)

 );


// Instantiate the ALU

alu_module top_alu_module
(
 .AluControl(AluControl),
 .A(SrcA),
 .B(SrcB),
 .ZeroFlag(zeroFlag),
 .SignFlag(signFlag),
 .ALUResult(ALUResult)

);

// Instantiate the Data Memory
data_mem_module data_mem_top
(
    .clk(clk),
    .WE(MemWrite),
    .WD(WriteData),
    .A(ALUResult),
    .RD(ReadData)

);

// Instantiate the sign extension 
Sign_Extend top_sign_extend
(
    .ImmSrc(ImmSrc),
    .Inst(Inst),
    .ImmExt(ImmExt)
);

assign SrcB = ALUSrc ?  ImmExt : WriteData ;
assign Result = ResultSrc ? ReadData : ALUResult ;

endmodule