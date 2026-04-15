`timescale 1ns / 1ps

// Button Synchronizer (Level-to-Pulse Converter)
// Converts a button press (level) to a single clock-cycle pulse.
// State diagram from lab handout:
//   State 00 (Low, Waiting for rise): P=0. If L=1 -> go to 01; if L=0 -> stay 00
//   State 01 (Edge Detected!):        P=1. Go to 11 unconditionally
//   State 11 (High, Waiting for fall): P=0. If L=1 -> stay 11; if L=0 -> go 00

module ButtonSync(Clk, Rst, bi, bo);
    input Clk, Rst, bi;
    output reg bo;
    
    reg [1:0] state;
    
    parameter S_LOW  = 2'b00;  // Low input, waiting for rise
    parameter S_EDGE = 2'b01;  // Edge detected, output pulse
    parameter S_HIGH = 2'b11;  // High input, waiting for fall
    
    always @(posedge Clk) begin
        if (Rst) begin
            state <= S_LOW;
            bo <= 0;
        end
        else begin
            case (state)
                S_LOW: begin
                    if (bi == 1) begin
                        state <= S_EDGE;
                        bo <= 1;       // pulse output in EDGE state
                    end
                    else begin
                        state <= S_LOW;
                        bo <= 0;
                    end
                end
                S_EDGE: begin
                    // Unconditionally go to HIGH state
                    state <= S_HIGH;
                    bo <= 0;
                end
                S_HIGH: begin
                    if (bi == 0) begin
                        state <= S_LOW;
                    end
                    else begin
                        state <= S_HIGH;
                    end
                    bo <= 0;
                end
                default: begin
                    state <= S_LOW;
                    bo <= 0;
                end
            endcase
        end
    end
endmodule
