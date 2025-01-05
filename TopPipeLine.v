module TopPipeline (
    input wire clock,
    input wire reset
);

wire [31:0] w_instruction;
wire [31:0] w_branchPC;  // Branch PC address
reg [31:0]  r1_instruction = 0;


wire [31:0] w_pc;
reg  [31:0] r1_pc = 0;
reg  [31:0] r2_pc = 0;
reg  [31:0] r3_pc = 0;
reg  [31:0] r4_pc = 0;
     
     
/////IF UNIT  
IFunit IFF (
    .clock          (clock),
    .branchPC       (w_branchPC),   // Branch target address
    .isBranchTaken  (w_isBranchTaken),     // Signal indicating if branch is taken
    .instruction    (w_instruction), // Fetched instruction
    .pc             (w_pc)
);


// 1st stage pipeline
always @(posedge clock) begin
   
    //1st unit 
    r1_instruction <= w_instruction;
    r1_pc          <= w_pc; 
end

// Control Unit

wire w_isSt;
wire w_isLd; 
wire w_isBeq; 
wire w_isBgt; 
wire w_isRet; 
wire w_isImmediate;
wire w_isWb; 
wire w_isUbranch; 
wire w_isCall; 
wire w_isMov;
wire [4:0] w_Alu_Signal;

reg r2_isSt = 0; 
reg r2_isLd = 0; 
reg r2_isBeq = 0; 
reg r2_isBgt = 0; 
reg r2_isRet = 0; 
reg r2_isImmediate = 0;
reg r2_isWb = 0; 
reg r2_isUbranch = 0; 
reg r2_isCall = 0; 
reg r2_isMov = 0;


reg r3_isSt; 
reg r3_isLd; 
reg r3_isBeq; 
reg r3_isBgt; 
reg r3_isRet; 
reg r3_isImmediate;
reg r3_isWb; 
reg r3_isUbranch; 
reg r3_isCall; 
reg r3_isMov;

reg r4_isSt; 
reg r4_isLd; 
reg r4_isBeq; 
reg r4_isBgt; 
reg r4_isRet; 
reg r4_isImmediate;
reg r4_isWb; 
reg r4_isUbranch; 
reg r4_isCall; 
reg r4_isMov;

Cunit CU(
    .Instruction        (r1_instruction), // 6-bit opcode input: {op5, op4, op3, op2, op1, op0}
    .isSt               (w_isSt), 
    .isLd               (w_isLd), 
    .isBeq              (w_isBeq), 
    .isBgt              (w_isBgt), 
    .isRet              (w_isRet), 
    .isImmediate        (w_isImmediate), 
    .isWb               (w_isWb), 
    .isUbranch          (w_isUbranch), 
    .isCall             (w_isCall),
    .isMov              (w_isMov),
    .Alu_Signal         (w_Alu_Signal)
);
  
wire [31:0] w_branchTarget;
wire [31:0] w_op1;
wire [31:0] w_op2;
wire [31:0] w_B;


reg [31:0] r_branchTarget;
reg [31:0] r_op1;
reg [31:0] r_op2;
reg [31:0] r_B;
reg [4:0] r_Alu_Signal;
reg [31:0] r2_instruction;


reg [3:0]  r_writeRegAddr; // Write-back register address
reg [31:0] r_writeData;   // Data to be written to the register
reg         r5_isWb;
OFUnit OFU(
    .instruction    (r1_instruction),
    .PC             (r1_pc),
    .isSt           (w_isSt),              // Store instruction signal
    .isRet          (w_isRet),             // 'ret' instruction signals
    .isImmediate    (w_isImmediate),
    .isWb           (r4_isWb),              // Write-back signal (write to register file)
    .writeRegAddr   (r_writeRegAddr),     // Write-back register address
    .writeData      (r_writeData),       // Data to be written to the register
    .branchTarget   (w_branchTarget),
    .B              (w_B),
    .op1            (w_op1),
    .op2            (w_op2)
);

// 2nd stage pipelining
always @(posedge clock) begin
    
    
    //2nd unit
    r_branchTarget <= w_branchTarget;
    r_op1          <= w_op1;
    r_B            <= w_B;
    r_op2          <= w_op2;
    r2_pc          <= r1_pc;
    r_Alu_Signal   <= w_Alu_Signal;
    r2_instruction <= r1_instruction;
    
    r2_isBeq       <=          w_isBeq;     
    r2_isBgt       <=          w_isBgt;
    r2_isRet       <=          w_isRet; 
    r2_isUbranch   <=          w_isUbranch; 
    
    
    //for 3rd and 4th unit  
    r2_isSt        <=          w_isSt; // OF - RW
    r2_isLd        <=          w_isLd;  // OF - RW
    r2_isWb        <=          w_isWb;         
    r2_isCall      <=          w_isCall; 
    
end


// Execute Unit
wire [31:0] w_aluResult; // ALU result


reg [31:0] r_aluResult; // ALU result
reg [31:0] r2_op2;
reg [31:0] r3_instruction;

EXUnit EXU(
    .op1                (r_op1),          // First operand
    .B                  (r_B),            // Second operand from register file
    .branchTarget       (r_branchTarget), // Branch target address
    .Alu_Signal         (r_Alu_Signal),              // ALU operation signals
    .isRet              (r2_isRet),              // Return instruction indicator
    .isBeq              (r2_isBeq),              // BEQ branch instruction indicator
    .isBgt              (r2_isBgt),              // BGT branch instruction indicator
    .isUbranch          (r2_isUbranch),             // Unconditional branch indicator
    .aluResult          (w_aluResult),   // ALU result
    .branchPC           (w_branchPC),  // Branch PC address
    .isBranchTaken      (w_isBranchTaken) // Branch taken signal
     
);

// 3rd Stage pipelining
always @(posedge clock) 
   begin
   
   
   //3rd unit 
   r_aluResult     <=   w_aluResult; // ALU result
   r2_op2          <=   r_op2;
   r3_pc           <=   r2_pc;
   r3_instruction  <=   r2_instruction;
   
   // for 4th unit 
    r3_isSt        <=          r2_isSt; // OF - RW
    r3_isLd        <=          r2_isLd;  // OF - RW
    r3_isWb        <=          r2_isWb;    
    r3_isCall      <=          r2_isCall;   
    
       
 
   
end



// Memory Unit
wire [31:0] w_ldResult;  
reg  [31:0] r_ldResult;                   // Value loaded from memory (load instruction)
reg  [31:0] r4_instruction;

MAUnit MAU(
    .op2                (r2_op2),                         // Value to be stored (store instruction)endmodule
    .aluR               (r_aluResult),                        // Address for memory access
    .isSt               (r3_isSt),                               // Store instruction signal
    .isLd               (r3_isLd),                               // Load instruction signal
    .ldResult           (w_ldResult)                     // Value loaded from memory (load instruction)
);

reg [31:0] r2_aluResult;
 
// 4th stage pipelining  
always @(posedge clock) begin 
    r_ldResult     <=          w_ldResult;
    r4_pc          <=          r3_pc;
    r2_aluResult   <=          r_aluResult;
    r4_instruction <=          r3_instruction;
    
   
    r4_isLd        <=          r3_isLd;           
    r4_isWb        <=          r3_isWb;         
    r4_isCall      <=          r3_isCall;      
    
end

// Write back Unit
wire [3:0]  w_writeRegAddr; // Write-back register address
wire [31:0] w_writeData;   // Data to be written to the register



    
RWUnit  RWU(
    .aluResult          (r2_aluResult),   // ALU computation result
    .ldResult           (r_ldResult),    // Load result from memory
    .PC                 (r4_pc),          // Current Program Counter
    .instruction        (r4_instruction),           // Destination register (bits 23-26 of the instruction)
    .isLd               (r4_isLd),               // Control signal for load instruction
    .isCall             (r4_isCall),             // Control signal for call instruction
    .writeRegAddr       (w_writeRegAddr), // Write-back register address
    .writeData          (w_writeData)   // Data to be written to the register
);

// 5th stage pipeling
always @(posedge clock) begin
    r_writeRegAddr <= w_writeRegAddr; // Write-back register address
    r_writeData    <= w_writeData;
    r5_isWb        <= r4_isWb;
end

endmodule 