`timescale 1ns / 1ps

// Light Pattern Generator FSM for Ping-Pong Game
// Inputs:  Clk, Rst (synchronous), Start, Play
// Outputs: LD3, LD2, LD1, LD0

module LightPatternGen(Clk, Rst, Start, Play, LD3, LD2, LD1, LD0);
    input Clk, Rst, Start, Play;
    output reg LD3, LD2, LD1, LD0;
    
    // State encoding
    reg [3:0] state;
    
    parameter S_IDLE     = 4'd0;   // All LEDs off, wait for Start
    parameter S_LD3      = 4'd1;   // LD3 on (ball starts / moving right)
    parameter S_LD2      = 4'd2;   // LD2 on
    parameter S_LD1      = 4'd3;   // LD1 on
    parameter S_LD0      = 4'd4;   // LD0 on (wall - rightmost)
    parameter S_LD1_BACK = 4'd5;   // LD1 on (bouncing back)
    parameter S_LD2_BACK = 4'd6;   // LD2 on (bouncing back)
    parameter S_LD3_BACK = 4'd7;   // LD3 on (back at player - check Play)
    parameter S_BLINK_ON = 4'd8;   // Game over: all LEDs on
    parameter S_BLINK_OFF= 4'd9;   // Game over: all LEDs off
    
    always @(posedge Clk) begin
        if (Rst) begin
            state <= S_IDLE;
            LD3 <= 0;
            LD2 <= 0;
            LD1 <= 0;
            LD0 <= 0;
        end
        else begin
            case (state)
                S_IDLE: begin
                    if (Start) begin
                        state <= S_LD3;
                        LD3 <= 1;
                        LD2 <= 0;
                        LD1 <= 0;
                        LD0 <= 0;
                    end
                    else begin
                        state <= S_IDLE;
                        LD3 <= 0;
                        LD2 <= 0;
                        LD1 <= 0;
                        LD0 <= 0;
                    end
                end
                
                S_LD3: begin
                    state <= S_LD2;
                    LD3 <= 0;
                    LD2 <= 1;
                    LD1 <= 0;
                    LD0 <= 0;
                end
                
                S_LD2: begin
                    state <= S_LD1;
                    LD3 <= 0;
                    LD2 <= 0;
                    LD1 <= 1;
                    LD0 <= 0;
                end
                
                S_LD1: begin
                    state <= S_LD0;
                    LD3 <= 0;
                    LD2 <= 0;
                    LD1 <= 0;
                    LD0 <= 1;
                end
                
                S_LD0: begin
                    // Ball hits wall, bounces back
                    state <= S_LD1_BACK;
                    LD3 <= 0;
                    LD2 <= 0;
                    LD1 <= 1;
                    LD0 <= 0;
                end
                
                S_LD1_BACK: begin
                    state <= S_LD2_BACK;
                    LD3 <= 0;
                    LD2 <= 1;
                    LD1 <= 0;
                    LD0 <= 0;
                end
                
                S_LD2_BACK: begin
                    state <= S_LD3_BACK;
                    LD3 <= 1;
                    LD2 <= 0;
                    LD1 <= 0;
                    LD0 <= 0;
                end
                
                S_LD3_BACK: begin
                    // Ball is back at player position
                    // Check if Play button is pressed
                    if (Play) begin
                        // Player hits the ball - start moving right again
                        state <= S_LD2;
                        LD3 <= 0;
                        LD2 <= 1;
                        LD1 <= 0;
                        LD0 <= 0;
                    end
                    else begin
                        // Player missed - game over, start blinking
                        state <= S_BLINK_ON;
                        LD3 <= 1;
                        LD2 <= 1;
                        LD1 <= 1;
                        LD0 <= 1;
                    end
                end
                
                S_BLINK_ON: begin
                    state <= S_BLINK_OFF;
                    LD3 <= 0;
                    LD2 <= 0;
                    LD1 <= 0;
                    LD0 <= 0;
                end
                
                S_BLINK_OFF: begin
                    state <= S_BLINK_ON;
                    LD3 <= 1;
                    LD2 <= 1;
                    LD1 <= 1;
                    LD0 <= 1;
                end
                
                default: begin
                    state <= S_IDLE;
                    LD3 <= 0;
                    LD2 <= 0;
                    LD1 <= 0;
                    LD0 <= 0;
                end
            endcase
        end
    end
endmodule
