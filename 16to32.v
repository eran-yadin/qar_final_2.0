module pad_16_to_32_2 (
    input [15:0] data_in,   // הכניסה מהמונה (16 ביט)
    output [31:0] data_out  // היציאה ל-BCD או ל-MUX (32 ביט)
);

    // אנחנו מצמידים 16 אפסים לצד השמאלי (החזק) של המספר
    assign data_out = {16'b0, data_in};

endmodule