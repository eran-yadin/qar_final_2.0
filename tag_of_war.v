module push_ball (
    input  wire       CLOCK_50,  // 50 MHz clock from DE0
    input  wire [2:0] BUTTON,    // BUTTON[2]=Reset, BUTTON[1]=Left, BUTTON[0]=Right
    output reg  [9:0] LEDG       // 10 Green LEDs
);

    // 1. Clock Divider for Debouncing (~10ms tick)
    // 50,000,000 Hz / 100 Hz = 500,000 cycles
    reg [18:0] div_ctr;
    wire tick_10ms = (div_ctr == 19'd500_000);

    always @(posedge CLOCK_50) begin
        if (tick_10ms)
            div_ctr <= 19'd0;
        else
            div_ctr <= div_ctr + 1'b1;
    end

    // 2. Button Debouncing and Edge Detection
    // DE0 buttons are Active-Low, so we invert them (~BUTTON) to make logic easier
    reg left_d1, left_d2, left_prev;
    reg right_d1, right_d2, right_prev;

    always @(posedge CLOCK_50) begin
        if (tick_10ms) begin
            // Sample Left Button (BUTTON[1])
            left_d1   <= ~BUTTON[1];
            left_d2   <= left_d1;
            left_prev <= left_d2;

            // Sample Right Button (BUTTON[0])
            right_d1   <= ~BUTTON[0];
            right_d2   <= right_d1;
            right_prev <= right_d2;
        end
    end

    // Create a 1-clock-cycle pulse only when the button is freshly pressed
    wire move_right = (left_d2  && !left_prev  && tick_10ms); // Left player pushes ball right
    wire move_left  = (right_d2 && !right_prev && tick_10ms); // Right player pushes ball left

    // 3. Game State & Shift Logic
    always @(posedge CLOCK_50) begin
        // BUTTON[2] is used to reset the game (Active Low)
        if (!BUTTON[2]) begin
            // Place the ball exactly in the middle
            LEDG <= 10'b0000010000;
        end
        else begin
            // Right player pressed their button -> shift left
            if (move_left && !move_right) begin
                if (LEDG != 10'b1000000000) // Stop if it hit the left wall
                    LEDG <= LEDG << 1;
            end
            // Left player pressed their button -> shift right
            else if (move_right && !move_left) begin
                if (LEDG != 10'b0000000001) // Stop if it hit the right wall
                    LEDG <= LEDG >> 1;
            end
        end
    end

endmodule