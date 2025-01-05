/////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2024 01:35:44
// Design Name: 
// Module Name: RWUnit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RWUnit(
    input [31:0] aluResult,   // ALU computation result
    input [31:0] ldResult,    // Load result from memory
    input [31:0] PC,          // Current Program Counter
    input [31:0] instruction,           // Destination register (bits 23-26 of the instruction)
    input isLd,               // Control signal for load instruction
    input isCall,             // Control signal for call instruction
    output reg [3:0] writeRegAddr, // Write-back register address
    output reg [31:0] writeData   // Data to be written to the register
);



    // Calculate return address (PC + 4)
    wire [31:0] returnAddr = PC + 4;
    wire [3:0] rd = instruction[25:22];

    // Multiplexer to select data to be written (aluResult, ldResult, or returnAddr)
    always @(*) begin
        if (isCall) begin
            writeData = returnAddr; // Write return address for call
        end else if (isLd) begin
            writeData = ldResult;   // Write load result
        end else begin
            writeData = aluResult;  // Write ALU result for other instructions
        end
    end

    // Multiplexer to select destination register (rd or RA register)
    always @(*) begin
        if (isCall) begin
            writeRegAddr = 4'd15; // Return address register (RA)
        end else begin
            writeRegAddr = rd;    // Regular destination register
        end
    end

endmodule

