module Control_Unit ( 
    input  wire [6:0] opcode, 
    input  wire func7, 
    input  wire [2:0] func3, 
    input  wire Zero_Flag, 
    input  wire Sign_Flag,
    output wire [2:0] ALUControl,
    output wire RegWrite,
    output wire MemWrite,
    output wire Branch,
    output wire ALUSrc,
    output wire ResultSrc,
    output wire [1:0] ImmSrc,
    output wire PCSrc
);

// Wires to connect modules
wire [1:0] ALUOp_internal;

// Instantiate Main Decoder
Main_Decoder main_decoder_inst (
    .opcode (opcode),
    .ALUOp (ALUOp_internal),
    .Branch (Branch),
    .ResultSrc (ResultSrc),
    .MemWrite (MemWrite),
    .ALUSrc (ALUSrc),
    .ImmSrc (ImmSrc),
    .RegWrite (RegWrite)
);

// Instantiate ALU Decoder
ALU_Decoder alu_decoder_inst (
    .opcode (opcode),
    .func7 (func7),
    .ALUOP (ALUOp_internal),
    .func3 (func3),
    .ALUControl (ALUControl)
);

// Instantiate Branch Logic
Branch_Logic branch_logic_inst (
    .func3 (func3),
    .Zero_Flag (Zero_Flag),
    .Sign_Flag (Sign_Flag),
    .Branch (Branch),
    .PCSrc (PCSrc)
);

endmodule