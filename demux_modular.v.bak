module victory_lights #(
    parameter CLK_SPEED = 50000000, // מהירות השעון בלוח (50MHz)
    parameter SPEED_HZ = 15         // מהירות האנימציה (זזות לשנייה)
                                    // נסה לשנות ל-10 לאיטי יותר, או 25 למהיר יותר
)(
    input clk,                      // שעון מערכת (חובה לחבר ל-PIN_B8!)
    input resetN,                   // איפוס (Active Low)
    input enable,                   // האות שמפעיל את חגיגת הניצחון (למשל סוויץ')
    output reg [9:0] leds           // יציאה ל-10 הלדים הירוקים בלוח
);

    // --- 1. מחלק שעון (להאטת הקצב) ---
    // אנחנו צריכים מונה שיספור עד מספר גבוה כדי ליצור השהייה
    reg [24:0] timer_counter;
    wire tick; // דופק איטי שקורה רק כשהמונה מסיים לספור

    // חישוב מתי לייצר את הדופק (מתמטיקה של תדרים)
    // המונה יתאפס בכל פעם שהוא מגיע לערך הסף הזה
    assign tick = (timer_counter == ((CLK_SPEED / SPEED_HZ) - 1));

    always @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            timer_counter <= 0;
        end else if (enable) begin
            // המונה רץ רק כשהחגיגה מופעלת
            if (tick)
                timer_counter <= 0;
            else
                timer_counter <= timer_counter + 1;
        end else begin
            timer_counter <= 0;
        end
    end

    // --- 2. לוגיקת הזזת האורות (אפקט "Knight Rider") ---
    reg moving_left; // דגל כיוון: 1=שמאלה, 0=ימינה

    always @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            leds <= 10'b0000000000; // באיפוס הכל כבוי
            moving_left <= 1'b1;
        end else if (enable) begin
            // האורות זזים רק כשיש דופק 'tick' איטי
            if (tick) begin
                if (leds == 10'b0) leds <= 10'b0000000001; // התחלה: לד ראשון נדלק
                else if (moving_left) begin
                    leds <= leds << 1; // הזזה שמאלה
                    // אם הגענו לקצה השמאלי (לד 9), משנים כיוון לימין
                    if (leds[8]) moving_left <= 1'b0; 
                end else begin
                    leds <= leds >> 1; // הזזה ימינה
                    // אם הגענו לקצה הימני (לד 1), משנים כיוון לשמאל
                    if (leds[1]) moving_left <= 1'b1; 
                end
            end
        end else begin
            // כשהחגיגה נגמרת (enable=0), מכבים את האורות
            leds <= 10'b0000000000; 
            moving_left <= 1'b1;
        end
    end

endmodule