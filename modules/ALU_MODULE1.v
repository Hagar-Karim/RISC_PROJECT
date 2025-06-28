module alu_module 
(
   input wire [2:0] AluControl ,
   input wire [31:0] A, B,
   output reg ZeroFlag, SignFlag,
   output reg [31:0] ALUResult 

);

always@(*)
begin
case(AluControl)

3'b000 :  ALUResult = A + B;
3'b001 :  ALUResult = A << B[4:0];
3'b010 :  ALUResult = A - B;
3'b100 :  ALUResult = A ^ B;
3'b101 :  ALUResult = A >> B; //arethmetic shift
3'b110 :  ALUResult = A | B;
3'b111 :  ALUResult= A & B;
default : ALUResult= 32'b0;
endcase
ZeroFlag = (ALUResult == 0);
SignFlag = ALUResult[31];

end //always end
endmodule