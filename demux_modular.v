module demux_1to2_modular #(
    parameter WIDTH = 16 // ערך ברירת המחדל, ניתן לשינוי ב-Quartus
)(
    input [WIDTH-1:0] data_in, // כניסה ברוחב המשתנה
    input sel,                // ביט בחירה בודד (0 או 1)
    output reg [WIDTH-1:0] out0, 
    output reg [WIDTH-1:0] out1
);

    always @(*) begin
        // איפוס יציאות למניעת יצירת Latches (זיכרון לא רצוי)
        out0 = {WIDTH{1'b0}}; 
        out1 = {WIDTH{1'b0}};
        
        case (sel)
            1'b0: out0 = data_in; // ניתוב המידע ליציאה הראשונה
            1'b1: out1 = data_in; // ניתוב המידע ליציאה השנייה
        endcase
    end
endmodule