module demux_1to2_1bit (
    input data_in,   // האות שנכנס (למשל ה-press מהכפתור)
    input sel,       // ביט הבחירה (למשל SW0)
    output out0,     // יציאה 0 (תלך למונה A)
    output out1      // יציאה 1 (תלך למונה B)
);

    // לוגיקה פשוטה:
    // היציאה הראשונה נדלקת רק אם sel הוא 0
    assign out0 = data_in & (~sel);
    
    // היציאה השנייה נדלקת רק אם sel הוא 1
    assign out1 = data_in & sel;

endmodule