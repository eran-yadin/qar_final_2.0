module button_controller1 #(
    parameter CLK_HZ = 50000000,
    parameter DELAY_MS = 500,
    parameter REPEAT_MS = 200,
    parameter DOUBLE_MS = 400
)(
    input clk, resetN, din,
    output reg press, unpress, autorep, double
);
    // הרחבנו ל-32 ביט כדי למנוע גלישה ב-50MHz
    reg [31:0] repeat_counter; 
    reg [31:0] double_counter;
    
    // גבולות הספירה
    wire [31:0] CNT_DELAY  = (CLK_HZ / 1000) * DELAY_MS;
    wire [31:0] CNT_REPEAT = (CLK_HZ / 1000) * REPEAT_MS;
    wire [31:0] CNT_DOUBLE = (CLK_HZ / 1000) * DOUBLE_MS;

    reg btn_sync_0, btn_sync_1, btn_prev;
    reg waiting_for_second;

    always @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            press <= 0; unpress <= 0; autorep <= 0; double <= 0;
            repeat_counter <= 0; double_counter <= 0;
            btn_prev <= 0; waiting_for_second <= 0;
        end else begin
            press <= 0; unpress <= 0; autorep <= 0; double <= 0;
            btn_sync_0 <= !din; // היפוך כפתור Active-Low
            btn_sync_1 <= btn_sync_0;
            btn_prev <= btn_sync_1;

            if (btn_sync_1 && !btn_prev) begin
                press <= 1;
                repeat_counter <= 0;
                if (waiting_for_second) begin
                    double <= 1;
                    waiting_for_second <= 0;
                end
            end

            if (!btn_sync_1 && btn_prev) begin
                unpress <= 1;
                waiting_for_second <= 1;
                double_counter <= 0;
            end

            // לוגיקת החזרה האוטומטית
            if (btn_sync_1) begin
                if (repeat_counter < CNT_DELAY)
                    repeat_counter <= repeat_counter + 1;
                
                if (repeat_counter == CNT_DELAY) begin
                    autorep <= 1;
                    repeat_counter <= CNT_DELAY - CNT_REPEAT;
                end
            end else begin
                repeat_counter <= 0;
            end

            if (waiting_for_second) begin
                double_counter <= double_counter + 1;
                if (double_counter >= CNT_DOUBLE) waiting_for_second <= 0;
            end
        end
    end
endmodule