module Instruction_Memory
(
    input wire [31:0] A, // Address input 
    output [31:0] RD // Read Data output
);

// Memory array to hold instructions
reg [31:0] memory [63:0];
// Initialize memory with some instructions (for simulation purposes)
initial begin
    $readmemh("program.txt", memory); // Load instructions from a file
end

assign RD = memory[A[31:2]]; // Read instruction from memory based on address
endmodule