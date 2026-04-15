`timescale 1ns / 1ps

module ButtonSync_tb;
    reg Clk_s, Rst_s, bi;
    wire bo;
    
    // Instantiate the Button Synchronizer
    ButtonSync uut(.Clk(Clk_s), .Rst(Rst_s), .bi(bi), .bo(bo));
    
    // Generate clock with period of 20 ns
    initial begin
        Clk_s = 0;
        forever #10 Clk_s = ~Clk_s;
    end
    
    // Stimulus matching Figure 3 from the handout
    initial begin
        // Initialize inputs
        Rst_s = 1;
        bi = 0;
        
        // @ 1st rising edge: Rst_s = 1, FSM goes to initial state
        @(posedge Clk_s);
        #5;
        
        // @ 2nd rising edge: Rst_s = 0, bi = 0 -> bo = 0
        Rst_s = 0;
        @(posedge Clk_s);
        #5;
        
        // @ 3rd rising edge: bi = 1 -> edge detected, bo = 1 (one cycle pulse)
        bi = 1;
        @(posedge Clk_s);
        // @ 4th rising edge: bi still 1, but bo goes back to 0 (waiting for fall)
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        // Release button
        #5;
        bi = 0;
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        // Press button again - should get another single-cycle pulse
        #5;
        bi = 1;
        @(posedge Clk_s);
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        // Release
        #5;
        bi = 0;
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        // Short press (1 cycle)
        #5;
        bi = 1;
        @(posedge Clk_s);
        #5;
        bi = 0;
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        // Test reset during operation
        #5;
        bi = 1;
        @(posedge Clk_s);
        Rst_s = 1;
        @(posedge Clk_s);
        Rst_s = 0;
        bi = 0;
        @(posedge Clk_s);
        @(posedge Clk_s);
        
        $finish;
    end
endmodule
