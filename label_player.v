module label_generator (
    input sel,               // חיבור ל-SW[0] (בוחר בין P1 ל-P2)
    output [6:0] seg_P,      // יציאה לצג ה-Thousands (תמיד P)
    output reg [6:0] seg_num // יציאה לצג ה-Hundreds (1 או 2)
);

    // האות P קבועה
    assign seg_P = 7'b0001100; 

    always @(*) begin
        if (sel == 1'b0)
            seg_num = 7'b1111001; // מציג '1'
        else
            seg_num = 7'b0100100; // מציג '2'
    end

endmodule