
module EXUnit (
    input [31:0] op1,         // First operand
    input [31:0] B,         // Second operand from register file
    input [31:0] branchTarget, // Branch target address
    input [4:0] Alu_Signal,   // ALU operation signals
    input isRet,              // Return instruction indicator
    input isBeq,              // BEQ branch instruction indicator
    input isBgt,              // BGT branch instruction indicator
    input isUbranch,          // Unconditional branch indicator
    output reg [31:0] aluResult, // ALU result
    output reg [31:0] branchPC,  // Branch PC address
    output reg isBranchTaken // Branch taken signal
     
);
     reg [1:0] flags; // Output flags register: {E, GT}
    // ALU Operations
    parameter ADD = 5'b00000, SUB = 5'b00001,MUL = 5'b00010, DIV = 5'b00011, MOD = 5'b00100;
    parameter CMP = 5'b00101, AND = 5'b00110,OR  = 5'b00111,NOT = 5'b01000;
    parameter MOV = 5'b01001;
    parameter LSL = 5'b01010, LSR = 5'b01011, ASR = 5'b01100;

    // Compute the branch PC based on isRet signal
    always @(*) begin
        branchPC = isRet ? op1 : branchTarget;
    end

    // Compute the branch outcome based on flags and branch type
    always @(*) begin
        isBranchTaken = (isUbranch) || 
                        (isBeq && flags[1]) ||  // E bit for equality
                        (isBgt && flags[0]);    // GT bit for greater than
    end

    // ALU Logic with Flag Updates
    always @(*) begin
        case (Alu_Signal)
            ADD: aluResult = op1 + B;
            SUB: aluResult = op1 - B;
            CMP: begin
                aluResult = op1 - B;
                // Set flags based on the result
                flags[1] = (aluResult == 0) ? 1 : 0; // E bit set if result is 0
                flags[0] = (aluResult > 0) ? 1 : 0;  // GT bit set if result > 0
            end
            MUL: aluResult = op1 * B;
            DIV: aluResult = op1 / B;
            MOD: aluResult = op1 % B;
            LSL: aluResult = op1 << B;
            LSR: aluResult = op1 >> B;
            ASR: aluResult = $signed(op1) >>> B;
            OR:  aluResult = op1 | B;
            AND: aluResult = op1 & B;
            NOT: aluResult = ~op1;
            MOV: aluResult = B;
            default: aluResult = 32'b0; // Default to 0
        endcase
    end

endmodule




/*
module EXUnit(
    input wire [31:0] op1,           // First operand
    input wire [31:0] op2,           // Second operand
    input wire [31:0] immediate,     // Immediate value (32-bit)
    input wire [2:0] aluS,           // ALU operation selector
    input wire isMov,                // Indicates 'mov' instruction
    input wire isBeq,                // Indicates 'beq' instruction
    input wire isBgt,                // Indicates 'bgt' instruction
    input wire isUBranch,            // Indicates unconditional branch
    input wire isImmediate,          // Indicates if the instruction uses an immediate
    output reg [31:0] aluR,          // Result of ALU operation
    output reg isBranchTaken         // Indicates if the branch is taken
);

    // Internal signals for equality and greater-than comparisons
    reg E;   // Stores result of equality operation
    reg GT;  // Stores result of greater-than operation

    // Internal operands for the ALU
    wire [31:0] A = op1;
    wire [31:0] B = (isImmediate) ? immediate : op2;

    // ALU operation logic
    always @(*) begin
        case (aluS)
            3'b000: aluR = A + B;                         // Addition
            3'b001, 
            3'b100: aluR = A - B;                         // Subtraction
            3'b010: aluR = A & B;                         // Bitwise AND
            3'b011: aluR = A | B;                         // Bitwise OR
            3'b101: aluR = ~B;                            // Bitwise NOT
            3'b110: aluR = A << B;                        // Shift left
            default: aluR = (isMov) ? B : 32'b0;          // 'mov' or default operation
        endcase
    end

    // Equality (E) and greater-than (GT) signal logic
    always @(*) begin
        if (aluS == 3'b100) begin
            E = (A == B);  // Equality check for 'beq'
            GT = (A > B);  // Greater-than check for 'bgt'
        end else begin
            E = 1'b0;
            GT = 1'b0;
        end
    end

    // Branch taken logic
    always @(*) begin
        isBranchTaken = (isBeq && E) || (isBgt && GT) || isUBranch;
    end

endmodule

*/