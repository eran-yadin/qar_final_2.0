// Edge Detector Module
// Generates a single clock-cycle pulse on a rising edge
module edge_detector (
    input clk,      // Connect to CLOCK_50
    input btn,      // Connect to button (use NOT gate before if Active-Low)
    output pulse    // Connect to counter enable (cnt_en)
);
    reg btn_prev;

    always @(posedge clk) begin
        // Store the button state from the previous clock cycle
        btn_prev <= btn;
    end

    // Logic: Current state is HIGH and previous state was LOW
    assign pulse = btn && !btn_prev;

endmodule