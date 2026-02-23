module demux_1to2_16bit (
    input [15:0] data_in,    // הכניסה (16 ביט)
    input sel,               // ביט הבחירה (0 או 1)
    output reg [15:0] out0,  // יציאה 0
    output reg [15:0] out1   // יציאה 1
);

    always @(*) begin
        // ברירת מחדל: היציאות מאופסות
        out0 = 16'd0;
        out1 = 16'd0;
        
        case (sel)
            1'b0: out0 = data_in; // ניתוב המידע ליציאה הראשונה
            1'b1: out1 = data_in; // ניתוב המידע ליציאה השנייה
        endcase
    end
    
endmodule