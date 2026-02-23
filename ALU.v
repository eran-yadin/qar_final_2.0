module alu_32bit (
    input [15:0] A,          // Number A from Counter 1
    input [15:0] B,          // Number B from Counter 2
    input [1:0]  op_select,  // Operation select (e.g., from SW[9:8])
    output reg [31:0] result // 32-bit output for BCD converter
);

    always @(*) begin
        case (op_select)
            2'b00: result = {16'd0, (A + B)};          // Addition
            2'b01: begin                               // Subtraction
                if (A >= B)
                    result = {16'd0, (A - B)};
                else
                    result = 32'd0; // Optional: handle negative or stay at 0
            end
            2'b10: result = A * B;                     // Multiplication
            2'b11: begin                               // Division
                if (B != 0)
                    result = {16'd0, (A / B)};
                else
                    result = 32'hFFFFFFFF; // Error indicator for Div by Zero
            end
            default: result = 32'd0;
        endcase
    end
endmodule