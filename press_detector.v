module button_controller #(
    parameter CLK_HZ = 50000000,
    parameter DELAY_MS = 500,       // Time before auto-repeat starts
    parameter REPEAT_MS = 200,      // Rate of auto-repeat pulses
    parameter DOUBLE_MS = 400       // Window for double click
)(
    input clk,      // 50MHz clock
    input resetN,   // Active-low reset
    input din,      // Raw button input (Active-Low)
    output reg press,    // Pulse on initial press
    output reg unpress,  // Pulse on release
    output reg autorep,  // Pulse during long press
    output reg double    // Pulse on double click
);

    // Internal constants for counters
    localparam CNT_DELAY  = (CLK_HZ / 1000) * DELAY_MS;
    localparam CNT_REPEAT = (CLK_HZ / 1000) * REPEAT_MS;
    localparam CNT_DOUBLE = (CLK_HZ / 1000) * DOUBLE_MS;

    // Synchronize and debounce input
    wire btn_clean = !din; // Invert here if buttons are active-low
    reg btn_sync_0, btn_sync_1;
    always @(posedge clk) begin
        btn_sync_0 <= btn_clean;
        btn_sync_1 <= btn_sync_0;
    end

    reg [23:0] repeat_counter;
    reg [23:0] double_counter;
    reg btn_prev;
    reg waiting_for_second;

    always @(posedge clk or negedge resetN) begin
        if (!resetN) begin
            press <= 0; unpress <= 0; autorep <= 0; double <= 0;
            repeat_counter <= 0; double_counter <= 0;
            btn_prev <= 0; waiting_for_second <= 0;
        end else begin
            // Default pulse values
            press <= 0; unpress <= 0; autorep <= 0; double <= 0;
            btn_prev <= btn_sync_1;

            // --- Press Detection (Edge) ---
            if (btn_sync_1 && !btn_prev) begin
                press <= 1;
                repeat_counter <= 0;
                
                if (waiting_for_second) begin
                    double <= 1;
                    waiting_for_second <= 0;
                end
            end

            // --- Release Detection ---
            if (!btn_sync_1 && btn_prev) begin
                unpress <= 1;
                waiting_for_second <= 1;
                double_counter <= 0;
            end

            // --- Auto-Repeat Logic ---
            if (btn_sync_1) begin
                repeat_counter <= repeat_counter + 1;
                if (repeat_counter == CNT_DELAY) begin
                    autorep <= 1;
                    repeat_counter <= CNT_DELAY - CNT_REPEAT; // Reset to repeat interval
                end
            end

            // --- Double Click Window Logic ---
            if (waiting_for_second) begin
                double_counter <= double_counter + 1;
                if (double_counter >= CNT_DOUBLE) begin
                    waiting_for_second <= 0;
                end
            end
        end
    end
endmodule