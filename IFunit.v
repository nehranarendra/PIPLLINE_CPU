module IFunit (
    input wire clock,
    input wire [31:0] branchPC,   // Branch target address
    input wire isBranchTaken,     // Signal indicating if branch is taken
    output reg [31:0] instruction, // Fetched instruction
    output reg [31:0] pc
);

  //  reg [31:0] pc = 0;                             // Program counter (initialized to 0)
  reg [31:0] instruction_memory [0:31];         // Example instruction memory 
  initial pc = -4;
    // Initialize instruction memory
   initial begin
    // Instruction initialization (RISC-V format)
    instruction_memory[0]  = 32'h00000013; // NOP (addi x0, x0, 0)
    instruction_memory[1]  = { 5'b01001,1'b1,4'b0010, 22'd10  };
    instruction_memory[2]  = 32'h00000013; // NOP (addi x0, x0, 0)
    instruction_memory[3]  = 32'h00000013; // NOP (addi x0, x0, 0)
    instruction_memory[4]  = 32'h00000013; // NOP (addi x0, x0, 0)
    instruction_memory[5]  = 32'h00000013; // NOP (addi x0, x0, 0)
    
    instruction_memory[6]  = { 5'b01001,1'b0,4'b0011, 4'b0 ,4'b0010 ,14'b0 };
  /*  instruction_memory[2]  = 32'h00200113; // addi x2, x0, 2 (x2 = 2)
    instruction_memory[3]  = 32'h00308193; // addi x3, x1, 3 (x3 = 4)
    instruction_memory[4]  = 32'h00408213; // addi x4, x1, 4 (x4 = 5)
    instruction_memory[5]  = 32'h00510293; // addi x5, x2, 5 (x5 = 7)
    instruction_memory[6]  = 32'h00618313; // addi x6, x3, 6 (x6 = 10)
    instruction_memory[7]  = 32'h00720393; // addi x7, x4, 7 (x7 = 12)
    instruction_memory[8]  = 32'h00828413; // addi x8, x5, 8 (x8 = 15)
    instruction_memory[9]  = 32'h00930513; // addi x9, x6, 9 (x9 = 19)
    instruction_memory[10] = 32'h00A38593; // addi x11, x7, 10 (x11 = 22)
    instruction_memory[11] = 32'h00B40613; // addi x12, x8, 11 (x12 = 26)
    instruction_memory[12] = 32'h00C48693; // addi x13, x9, 12 (x13 = 31)
    instruction_memory[13] = 32'h00D50713; // addi x14, x10, 13 (x14 = 36)
    instruction_memory[14] = 32'h00E58793; // addi x15, x11, 14 (x15 = 41)
    instruction_memory[15] = 32'h00F60793; // addi x16, x12, 15 (x16 = 45)
    instruction_memory[16] = 32'h01068893; // addi x17, x13, 16 (x17 = 49)
    instruction_memory[17] = 32'h01170993; // addi x18, x14, 17 (x18 = 53)
    instruction_memory[18] = 32'h01278A93; // addi x19, x15, 18 (x19 = 57)
    instruction_memory[19] = 32'h01380B13; // addi x20, x16, 19 (x20 = 61)
    instruction_memory[20] = 32'h01488B93; // addi x21, x17, 20 (x21 = 65)
    */
end




    // PC Update Logic (Synchronized with clock edge)
  always @(negedge clock) begin
        if (isBranchTaken)
            pc <= branchPC;   // If branch is taken, jump to branch target
        else
            pc <= pc + 4;     // Otherwise, increment PC by 4
            instruction <= instruction_memory[pc >> 2 ];
    end
 
    

    

endmodule


