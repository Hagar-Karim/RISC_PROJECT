module Sign_Extend
(
    input wire [31:0] Inst, // 32-bit instruction input
    input wire [1:0] ImmSrc, // Sign extension control signal
    output reg [31:0] ImmExt // 32-bit extended immediate value
);

always @(*) begin
    case (ImmSrc)
        2'b00: ImmExt = {{20{Inst[31]}}, Inst[31:20]}; // 12-bit sign immediate extension
        2'b01: ImmExt = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]}; // 12-bit sign immediate extension
        2'b10: ImmExt = {{20{Inst[31]}},Inst[7],Inst[30:25],Inst[11:8],1'b0}; // 13-bit sign immediate extension
        default: ImmExt = 32'b0; // Default case
    endcase
end
endmodule