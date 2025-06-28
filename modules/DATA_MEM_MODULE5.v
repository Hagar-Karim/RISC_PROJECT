module data_mem_module #(parameter ADDR_WIDTH = 32 , DATA_WIDTH = 32 , ADDR_DEPTH = 64)
(
 input clk , WE , 
 input [DATA_WIDTH-1:0] WD,
 input [ADDR_WIDTH-1:0] A,
 output [DATA_WIDTH-1:0] RD
);

reg [DATA_WIDTH-1:0] data_mem [ADDR_DEPTH-1:0];

always @ (posedge clk)
begin 
  if (WE)
    data_mem[A[31:2]] <= WD; 
end

assign RD = data_mem[A[31:2]]; 
endmodule