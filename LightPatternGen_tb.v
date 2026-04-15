`timescale 1ns / 1ps

module LightPatternGen_tb;
    reg Clk_tb, rst_tb, start_tb, play_tb;
    wire LD3_tb, LD2_tb, LD1_tb, LD0_tb;
    integer i;
    
    // Instantiate the Light Pattern Generator
    LightPatternGen uut(
        .Clk(Clk_tb), 
        .Rst(rst_tb), 
        .Start(start_tb), 
        .Play(play_tb), 
        .LD3(LD3_tb), 
        .LD2(LD2_tb), 
        .LD1(LD1_tb), 
        .LD0(LD0_tb)
    );
    
    // Generate clock with period of 200 ns (use #100)
    initial begin
        Clk_tb = 0;
        forever #100 Clk_tb = ~Clk_tb;
    end
    
    // Stimulus - matching the waveform from the handout (pages 8-9)
    initial begin
        // Initialize all inputs
        rst_tb = 1;
        start_tb = 0;
        play_tb = 0;
        
        // Hold reset for one clock cycle
        @(posedge Clk_tb);
        #50;
        rst_tb = 0;
        
        // Wait a clock cycle in IDLE state
        @(posedge Clk_tb);
        
        // ============================================================
        // TEST CASE 1: Start the game (start_tb = 1 for one clock cycle)
        // ============================================================
        #50 start_tb = 1;
        @(posedge Clk_tb);     // Start is sampled, FSM enters S_LD3
        #50 start_tb = 0;
        
        // Ball moves: LD3 -> LD2 -> LD1 -> LD0 -> LD1_BACK -> LD2_BACK -> LD3_BACK
        // Wait 6 clock edges for ball to travel to LD3_BACK
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // ============================================================
        // TEST CASE 2: Game over - play button NOT pressed at LD3_BACK
        // The ball is now at LD3_BACK, play is 0 -> game over (blinking)
        // ============================================================
        // Let it blink for several cycles to show game over
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // ============================================================
        // Reset the game after game over
        // ============================================================
        #50 rst_tb = 1;
        @(posedge Clk_tb);
        #50 rst_tb = 0;
        
        // Wait in IDLE
        @(posedge Clk_tb);
        
        // ============================================================
        // TEST CASE 3: Start new game and press play at the right time
        // ============================================================
        #50 start_tb = 1;
        @(posedge Clk_tb);     // Start sampled, FSM enters S_LD3
        #50 start_tb = 0;
        
        // Ball moves: LD3 -> LD2 -> LD1 -> LD0 -> LD1_BACK -> LD2_BACK -> LD3_BACK
        // Wait 6 edges to reach LD3_BACK
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // Now in LD3_BACK - press Play to continue the game
        #50 play_tb = 1;
        @(posedge Clk_tb);        // Play sampled at LD3_BACK -> continue
        #50 play_tb = 0;
        
        // Ball continues: LD2 -> LD1 -> LD0 -> LD1_BACK -> LD2_BACK -> LD3_BACK
        // Wait 6 edges
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // ============================================================
        // TEST CASE 4: Play pressed at right time again, then miss
        // ============================================================
        #50 play_tb = 1;
        @(posedge Clk_tb);        // Play sampled at LD3_BACK -> continue
        #50 play_tb = 0;
        
        // Ball moves again
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // Now at LD3_BACK, don't press play -> game over
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge Clk_tb);
        end
        
        // ============================================================
        // TEST CASE 5: Reset during ball movement (mid-game reset)
        // ============================================================
        #50 rst_tb = 1;
        @(posedge Clk_tb);
        #50 rst_tb = 0;
        @(posedge Clk_tb);
        
        // Start a new game
        #50 start_tb = 1;
        @(posedge Clk_tb);
        #50 start_tb = 0;
        
        // Wait 2 cycles (ball is at LD1)
        @(posedge Clk_tb);
        @(posedge Clk_tb);
        
        // Reset mid-game
        #50 rst_tb = 1;
        @(posedge Clk_tb);
        #50 rst_tb = 0;
        
        // Verify we're back in IDLE (all LEDs off)
        @(posedge Clk_tb);
        @(posedge Clk_tb);
        @(posedge Clk_tb);
        
        $finish;
    end
endmodule
