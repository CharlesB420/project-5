`timescale 1ns / 1ps

module Top_Design(CLK100MHZ, BTNU, BTNC, BTND, LED);
    input CLK100MHZ, BTNU, BTNC, BTND;
    output [3:0] LED;
        
    // The code below is to instantiate the ClkDiv module that
	//you can use for this part	
    wire ClkOut;
    ClkDiv a1(CLK100MHZ, 1'b0, ClkOut);


    //see figure 2 in the lab handout and add your code below to 
	//a) instantiate the Button synchronizer and make connections
	//b) instantiate the light pattern generator and make connections.		

    // a) Button Synchronizer for the Play button (BTND)
    //    Uses ClkOut as clock, reset tied to BTNU
    //    bi = BTND (raw button press), bo = play_sync (single pulse)
    wire play_sync;
    ButtonSync a2(.Clk(ClkOut), .Rst(BTNU), .bi(BTND), .bo(play_sync));

    // b) Light Pattern Generator FSM
    //    Uses ClkOut as clock
    //    Rst = BTNU (Up button), Start = BTNC (Center button)
    //    Play = play_sync (synchronized single pulse from ButtonSync)
    //    Outputs: LED[3:0]
    LightPatternGen a3(
        .Clk(ClkOut), 
        .Rst(BTNU), 
        .Start(BTNC), 
        .Play(play_sync), 
        .LD3(LED[3]), 
        .LD2(LED[2]), 
        .LD1(LED[1]), 
        .LD0(LED[0])
    );

endmodule
