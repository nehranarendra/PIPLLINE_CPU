

module MAUnit(
                          
    input wire [31:0] op2,                         // Value to be stored (store instruction)
    input wire [31:0] aluR,                        // Address for memory access
    input wire isSt,                               // Store instruction signal
    input wire isLd,                               // Load instruction signal
    output reg [31:0] ldResult                     // Value loaded from memory (load instruction)
);

    // Internal memory: 4096 bytes (32768 bits)
    reg [7:0] memory [0:4095];                     // Byte-addressable memory

    // Load logic: Fetch value from memory when 'isLd' is high
    always @(*) begin
        if (isLd) begin
            ldResult <= {memory[aluR], memory[aluR+1], memory[aluR+2], memory[aluR+3]};
        end else begin
            ldResult <= 32'h00000000;  // Default value when not loading
        end
    end

    // Store logic: Write value to memory on falling clock edge
    always @(*) begin
        if (isSt) begin
            memory[aluR]     <= op2[31:24];  // Store MSB byte
            memory[aluR + 1] <= op2[23:16];
            memory[aluR + 2] <= op2[15:8];
            memory[aluR + 3] <= op2[7:0];    // Store LSB byte
        end
    end

endmodule

