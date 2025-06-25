module Top
(
    input clk,
    input areset // Asynchronous reset signal
);

// Internal wires and registers
wire [31:0] PC, SrcA, SrcB, ALUResult, ImmExt, Inst, WriteData, ReadData;
wire [2:0] AluControl;
wire [1:0] ImmSrc;
wire zeroFlag, signFlag, PCSrc, ALUSrc, RegWrite, ResultSrc, MemWrite, load;

// Instantiate the Program Counter
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
    .func7(Inst[31:25]),
    .func3(Inst[14:12]),
    .Zero_Flag(zeroFlag),
    .Sign_Flag(signFlag),
    .ALUControl(AluControl),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .Branch(PCSrc),
    .ALUSrc(ALUSrc),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc)
);

// Instantiate the ALU 
alu_module top_alu
(
    .AluControl(AluControl),
    .A(SrcA),
    .B(ALUSrc ? ImmExt : SrcB), // Use immediate value if ALUSrc is set
    .ZeroFlag(zeroFlag),
    .SignFlag(signFlag),
    .ALUResult(ALUResult)
);

// Instantiate the data memory
data_mem_module top_data_mem
(
    .clk(clk),
    .areset(areset),
    .A(ALUResult),
    .WD(WriteData),
    .RD(ReadData),
    .MemWrite(MemWrite)
);

// Instantiate the Register File
rf_module top_rf
(
    .clk(clk),
    .rst_n(areset),
    .RegWrite(RegWrite),
    .A1(Inst[19:15]), // rs1
    .A2(Inst[24:20]), // rs2
    .A3(Inst[11:7]),  // rd
    .WD3(ResultSrc ? ReadData : ALUResult), // Write data from data memory or ALU
    .RD1(SrcA), // Read data from rs1
    .RD2(SrcB)  // Read data from rs2
);
// Instantiate the sign extension 
Sign_Extend top_sign_extend
(
    .ImmSrc(ImmSrc),
    .Inst(Inst[31:7]), // 32-bit instruction input
    .ImmExt(ImmExt)
);

endmodule