module rf_module #(parameter DATA_WIDTH=32, ADDR_DEPTH=32, ADDR_WIDTH=5)
(
    input wire clk, rst_n, WE3,
    input wire [ADDR_WIDTH-1:0] A1, A2, A3,
    input wire [DATA_WIDTH-1:0] WD3, 
    output [DATA_WIDTH-1:0] RD1, RD2
);

reg [DATA_WIDTH-1:0] registers[ADDR_DEPTH-1:0];
integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < ADDR_DEPTH; i = i+1)
            registers[i] <= 0;
    end
    else if (WE3) begin
            registers[A3] <= WD3;
    end
end

assign RD1 = registers[A1];
assign RD2 = registers[A2];

endmodule