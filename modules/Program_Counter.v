module Program_Counter
(
    input wire clk,
    input wire areset, // Asynchronous reset signal
    input wire load, // Load signal to update the program counter
    input wire PCSrc, // Program Counter Select signal
    input wire [31:0] ImmExt, // Immediate value for branch instructions
    output reg [31:0] PC // Next instruction address
    
);

wire [31:0] pc_next_inst; // Next instruction address
wire [31:0] pc_branch;
wire [31:0] pc; 
assign pc_next_inst = PC + 4; // Calculate the next instruction address
assign pc_branch = PC + ImmExt; // Calculate the branch address
assign pc = (PCSrc) ? pc_branch : pc_next_inst; // Select between next instruction or branch address

    // Update the program counter on the rising edge of the clock
    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            PC <= 32'b0; // Reset the program counter to zero
        end else if (load) begin
            PC <= pc; // Load the new instruction address
        end
    end

endmodule