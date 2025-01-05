
module Cunit (
    input  [31:0] Instruction,
    output [4:0]  Alu_Signal, // 6-bit opcode input: {op5, op4, op3, op2, op1, op0}
    output reg isSt, isLd, isBeq, isBgt, isRet, isImmediate, 
                isWb, isUbranch, isCall,isMov
);  

   // Internal signals for opcode and immediate bit extraction
    wire [4:0] op_code;
    wire I;

    // Extract the opcode and immediate bit from the instruction
    assign Alu_Signal = Instruction[31:27];  // Top 5 bits for opcode
    assign I = Instruction[26];           // Immediate bit
    
    

    // Combinational logic
    always @(*) begin
        // Default all signals to 0
        {isSt, isLd, isBeq, isBgt, isRet, isImmediate, 
         isWb, isUbranch, isCall, isMov} = 0;
         
          if (I) begin
            isImmediate = 1;
        end
        // Decode logic based on the given table
        casez (Alu_Signal)  // Using `casez` to handle bitwise don't-cares ('z')
            5'b011_11: isSt = 1;      // isSt: ops5.ops4.ops3.ops2.ops1
            5'b011_10:                 // isLd
                       begin 
                          isLd = 1;  
                          isWb = 1;
                       end    
            5'b100_00: isBeq = 1;     // isBeq
            5'b100_01: isBgt = 1;     // isBgt
            5'b101_00:                 // isRet
                      begin  
                         isRet = 1;
                         isUbranch = 1; 
                     end  
            5'b100_11:
                     begin           //iscall
                         isCall = 1;
                         isUbranch = 1; 
                    end  
            
            5'b100_10: isUbranch = 1;    
            
            5'b010_01:
                   begin           //isM0v   5'b01_001: isWb = 1;//isMOV = 1; 9
                         isMov = 1;
                         isWb = 1; 
                    end
                     

            // ALU signals (ops5.ops4.ops3.ops2.ops1 patterns)
            5'b00_000: isWb = 1;//isAdd = 1; 1
            5'b00_001: isWb = 1;//isSub = 1; 2
            5'b00_010: isWb = 1;//isMUL = 1; 3
            5'b00_011: isWb = 1;//isdiv = 1  4
            5'b00_100: isWb = 1;//isMOD = 1; 5
            5'b00_110: isWb = 1;//isand = 1; 6
            5'b00_111: isWb = 1;//isor = 1;  7
            5'b01_000: isWb = 1;//isNOT = 1; 8
           
            5'b01_010: isWb = 1;//isLSL = 1; 10
            5'b01_011: isWb = 1;//isLSR = 1; 11
            5'b01_100: isWb = 1; //isASR = 1; 12

            default: ;  // No match, all outputs remain 0
        endcase
    end
endmodule

/*
module Cunit(
    input  [31:0] Instruction, // 32-bit instruction from Instruction Fetch Unit
    output reg isMov,           // Is 'mov' instruction
    output reg isSt,            // Is 'st' instruction
    output reg isLd,            // Is 'ld' instruction
    output reg isBeq,           // Is 'beq' instruction
    output reg isBgt,           // Is 'bgt' instruction
    output reg isImmediate,     // Instruction has immediate arguments
    output reg isWb,            // Is write-back to register file required
    output reg isUBranch,       // Is it a direct branch (b, ret, call)?
    output reg isRet,           // Is 'ret' instruction
    output reg isCall,          // Is 'call' instruction
    output reg [2:0] aluS       // ALU operation state
);

    // Internal signals for opcode and immediate bit extraction
    wire [4:0] op_code;
    wire I;

    // Extract the opcode and immediate bit from the instruction
    assign op_code = Instruction[31:27];  // Top 5 bits for opcode
    assign I = Instruction[26];           // Immediate bit

    // Control logic for different instructions
    always @(*) begin
        // Default values for all outputs
        isMov = 0;
        isSt = 0;
        isLd = 0;
        isBeq = 0;
        isBgt = 0;
        isImmediate = 0;
        isWb = 0;
        isUBranch = 0;
        isRet = 0;
        isCall = 0;
        aluS = 3'b111;

        // Set the immediate flag if the immediate bit is set
        if (I) begin
            isImmediate = 1;
        end

        // Control logic based on the opcode
        case (op_code)
            5'b00000: begin // add
                isWb = 1;
            end
            5'b00001: begin // sub
                aluS = 3'b001;
                isWb = 1;
            end
            5'b00101: begin // cmp
                aluS = 3'b100;
            end
            5'b00110: begin // and
                aluS = 3'b010;
                isWb = 1;
            end
            5'b00111: begin // or
                aluS = 3'b011;
                isWb = 1;
            end
            5'b01000: begin // not
                aluS = 3'b101;
                isWb = 1;
            end
            5'b01010: begin // lsl
                aluS = 3'b110;
                isWb = 1;
            end
            5'b01001: begin // mov
                isMov = 1;
                isWb = 1;
            end
            5'b01110: begin // ld
                isLd = 1;
                isWb = 1;
                aluS = 3'b000;
            end
            5'b01111: begin // st
                isSt = 1;
                aluS = 3'b000;
            end
            5'b10000: begin // beq
                isBeq = 1;
            end
            5'b10001: begin // bgt
                isBgt = 1;
            end
            5'b10010: begin // b (unconditional branch)
                isUBranch = 1;
            end
            5'b10011: begin // call
                isCall = 1;
                isUBranch = 1;
            end
            5'b10100: begin // ret
                isRet = 1;
                isUBranch = 1;
            end
            default: begin
                // Default case: Do nothing (all outputs remain at 0)
            end
        endcase
    end

endmodule

*/