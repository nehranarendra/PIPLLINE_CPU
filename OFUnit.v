module OFUnit (
    input [31:0] instruction,
    input [31:0] PC,
    input wire isSt,              // Store instruction signal
    input wire isWb,              // Write-back signal (write to register file)
    input wire isRet,             // 'ret' instruction signal
    input wire isImmediate,
    input [3:0] writeRegAddr,     // Write-back register address
    input [31:0] writeData,       // Data to be written to the register
    output reg [31:0] branchTarget,
    output  [31:0] op1,
    output  [31:0] op2,
    output  [31:0] B
);

    reg [31:0] reg_file [0:15];
    reg [31:0] immx;
   
    
  wire [17:0] imm_field = instruction[17 : 0];
  wire [26:0] offset = instruction[ 27:0];
    
     always @(*) 
    begin
        case (instruction[18:17])
            2'b00: immx = $signed(imm_field[15:0]);
            2'b01: immx = {16'b0, imm_field[15:0]};
            2'b10: immx = {imm_field[15:0], 16'b0};
            default: immx = 32'b0;
        endcase
    end
    
  assign op2 = isSt ? reg_file[instruction[25:22]]:reg_file[instruction [17:14]];
  assign  B = isImmediate ? immx : op2;
  assign op1 = isRet ? reg_file[15]:reg_file[instruction[21:18]]; 
  
  
 always @(*) 
    begin
        branchTarget = ($signed(offset) << 2) + PC;
    end


    always @(*) begin
        if (isWb)
          reg_file[writeRegAddr]  =  writeData;
    end


endmodule


/*
module OFUnit(
    input wire clk,                                // Clock signal
    input wire [31:0] Instruction,                 // 32-bit instruction code
    input wire [31:0] PC,                          // Program counter
    input wire [31:0] aluR,                        // ALU result (to be written to register)
    input wire [31:0] ldR,                         // Load result (to be written to register)
    input wire isSt,                               // Store instruction signal
    input wire isLd,                               // Load instruction signal
    input wire isWb,                               // Write-back signal (write to register file)
    input wire isRet,                              // 'ret' instruction signal
    input wire isCall,                             // 'call' instruction signal
    output reg [31:0] immediate,                   // Immediate value
    output reg [31:0] branchTarget,                // Branch target address
    output reg [31:0] op1,                         // First operand
    output reg [31:0] op2                          // Second operand
);

    // Register file: 16 registers, each 32-bits wide
    reg [31:0] reg_file [0:15];

    // Temporary signal for signed extension of offset
    reg [31:0] temp;

    // Compute the immediate value based on instruction modifiers
    always @(*) begin
        if (Instruction[16]) begin
            immediate = {16'b0, Instruction[15:0]};  // Zero-extend immediate
        end else if (Instruction[17]) begin
            immediate = {Instruction[15:0], 16'b0};  // Shift left by 16 bits
        end else begin
            immediate = {{16{Instruction[15]}}, Instruction[15:0]};  // Sign-extend
        end
    end

    // Compute branch target: PC + (offset << 2)
    always @(*) begin
        temp = {{5{Instruction[26]}}, Instruction[26:0]};  // Sign-extend offset
        branchTarget = PC + (temp << 2);
    end

    // Operand fetching logic
    always @(*) begin
        // Fetch first operand (op1)
        if (isRet) begin
            op1 = reg_file[15];  // For 'ret', use register 15
        end else begin
            op1 = reg_file[Instruction[21:18]];  // Use rs1 field from instruction
        end

        // Fetch second operand (op2)
        if (isSt) begin
            op2 = reg_file[Instruction[25:22]];  // Use rd field for store instruction
        end else begin
            op2 = reg_file[Instruction[17:14]];  // Use rs2 field otherwise
        end
    end

    // Register write logic on falling clock edge
    always @(negedge clk) begin
        if (isWb && !isLd && !isCall) begin
            reg_file[Instruction[25:22]] <= aluR;  // Write ALU result to register
        end else if (isWb && isLd && !isCall) begin
            reg_file[Instruction[25:22]] <= ldR;  // Write load result to register
        end else if (isCall) begin
            reg_file[15] <= PC + 4;  // Save return address for 'call' instruction
        end
    end

endmodule


*/
