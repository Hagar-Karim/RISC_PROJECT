module Main_Decoder
(
    input [6:0] opcode, // Opcode input
    output reg [1:0] ALUOp, // ALU operation code
    output reg Branch, // Branch control signal
    output reg ResultSrc, // Result source select
    output reg MemWrite, // Memory write enable
    output reg ALUSrc, // ALU source select
    output reg [1:0] ImmSrc, // Immediate source select
    output reg RegWrite // Register write enable
);
localparam loadWord = 7'b0000011; // Load Word instruction
localparam storeWord = 7'b0100011; // Store Word instruction
localparam Rtype = 7'b0110011; // R-type instruction
localparam Itype = 7'b0010011; // I-type instruction
localparam branch = 7'b1100011; // Branch instruction

always @(*) begin
    // Default values
    ALUOp = 2'b00; 
    Branch = 0;
    ResultSrc = 0; 
    MemWrite = 0;
    ALUSrc = 0; 
    ImmSrc = 2'b00;
    RegWrite = 0;   

    case (opcode)
        loadWord: begin
            ALUOp = 2'b00; 
            ResultSrc = 1;
            ALUSrc = 1;
            ImmSrc = 2'b00; 
            RegWrite = 1;
            MemWrite = 0;
            Branch = 0; 
        end
        
        storeWord: begin
            ALUOp = 2'b00; // ALU operation for store
            Branch = 0; // No branch for store
            MemWrite = 1; // Enable memory write
            ALUSrc = 1; // Use immediate value for ALU operation
            ImmSrc = 2'b01;
            RegWrite = 0; // No register write for store
        end
        
        Rtype: begin
            ALUOp = 2'b10; // R-type operation (ALU operation)
            RegWrite = 1; // Enable register write
            ALUSrc = 0; // Use register values for ALU operation
            MemWrite = 0; // No memory write for R-type
            ResultSrc = 0; // Result comes from ALU
            Branch = 0; // No branch for R-type
        end
        
        Itype: begin
            ALUOp = 2'b10; // I-type operation (ALU operation)
            RegWrite = 1; // Enable register write
            ALUSrc = 1; // Use immediate value for ALU operation
            MemWrite = 0; // No memory write for I-type
            ResultSrc = 0; // Result comes from ALU
            ImmSrc = 2'b00; // Immediate source for I-type
            Branch = 0; // No branch for I-type
        end
        
        branch: begin
            ALUOp = 2'b01; // Branch operation (ALU operation)
            Branch = 1; // Enable branch control
            MemWrite = 0; // No memory write for branch
            ALUSrc = 0; // Use register values for ALU operation
            ImmSrc = 2'b10; // Immediate source for branch
            RegWrite = 0; // No register write for branch

        end
        
        default: begin
            ALUOp = 2'b00; 
            Branch = 0;
            ResultSrc = 0; 
            MemWrite = 0;
            ALUSrc = 0; 
            ImmSrc = 2'b00;
            RegWrite = 0;   
        end
    endcase 
    end
    endmodule

module ALU_Decoder 
(
 input wire [6:0] opcode , func7,
 input wire [1:0] ALUOP,
 input wire [2:0] func3,
 output reg [2:0] ALUControl

);

wire [1:0] op_func7 = {opcode[5] , func7[5]};

always@ (*)
begin
case (ALUOP)
2'b00 : ALUControl = 3'b000; //lw, sw

2'b01 : 
begin
if (func3 == 3'b000 || func3 == 3'b001 || func3 == 3'b100) // beq, bnq, blt
 ALUControl = 3'b010;
 else
 ALUControl = 3'b000;
end

2'b10:
begin
case (func3)
3'b000 : 
begin
if (op_func7 == 2'b00 || op_func7 == 2'b01 || op_func7 == 2'b10)
ALUControl = 3'b000;
else 
ALUControl = 3'b010;
end 

3'b001 : ALUControl = 3'b001;

3'b100 : ALUControl = 3'b100;

3'b101 : ALUControl = 3'b101;

3'b110 : ALUControl = 3'b110;

3'b111 : ALUControl = 3'b111;

default : ALUControl = 3'b000;
endcase
end

default : ALUControl = 3'b000;
endcase
end //always end
endmodule

module Branch_Logic

(  input [2:0] func3,
   input Zero_Flag, Sign_Flag, Branch, 
   output reg PCSrc
);

localparam beq = 3'b000,
           bne = 3'b001,
           blt = 3'b010;

always@ (*)
begin
case (func3)

beq : PCSrc = Zero_Flag & Branch;

bne : PCSrc = Branch & ~Zero_Flag;
 
blt : PCSrc = Branch & Sign_Flag;

default : PCSrc = 0;

endcase
end
endmodule
        