//module testbench();
//
//timeunit 10ns;
//timeprecision 1ns;
//							 
//
//logic CLOCK_50;
//logic [3:0]  KEY;     //bit 0 is set up as Reset
//logic [6:0]  HEX0, HEX1;
//
//logic [7:0]  VGA_R, VGA_G,VGA_B;      //VGA Blue
//logic        VGA_CLK;      //VGA Clock
//
// 
// game toplevel(.CLOCK_50, .KEY, .HEX0, .HEX1, .VGA_R, .VGA_G, .VGA_B, .VGA_CLK);// .OTG_DATA, .OTG_ADDR, .OTG_CS_N, .OTG_RD_N, .OTG_WR_N, .OTG_RST_N, .OTG_INT);
//
//// Toggle the clock
//// #1 means wait for a delay of 1 timeunit
//always begin : CLOCK_GENERATION
//#1 CLOCK_50 = ~CLOCK_50;
//end
//
//initial begin: CLOCK_INITIALIZATION
//    CLOCK_50 = 0;
//end 
//
//
//initial begin: TEST_VECTORS
//#20
//#8 KEY[0] = 0;
//#8 KEY[0] = 1;
//
//
//
//
//end
//endmodule

// TESTING ALIEN STATUS ARRAY
module testbench();

timeunit 10ns;
timeprecision 1ns;
logic CLOCK_50;

logic Reset_h, lose, win;
logic [2:0] curr_state;
logic [7:0] keycode;

 game_state state_machine(.Clk(CLOCK_50), .Reset(Reset_h), .keycode, .curr_state, .lose, .win);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLOCK_50 = ~CLOCK_50;
end

initial begin: CLOCK_INITIALIZATION
    CLOCK_50 = 0;
end 


initial begin: TEST_VECTORS

#8 Reset_h = 1'b1;
#2 Reset_h = 1'b0;
// tab from START
#6 keycode = 8'h2b;
#2 keycode = 8'h00;

//Pause and unpause
#8 keycode = 8'h14;
#8 keycode = 8'h00;
#8 keycode = 8'h14;
#8 keycode = 8'h00;

// Game Over 
#4 lose = 1'b1;
#2 lose = 1'b0;
#2 keycode = 8'h2b;
#2 keycode = 8'h00;

// WIn 
#4 win = 1'b1;
#2 win = 1'b0;
#2 keycode = 8'h2b;
#2 keycode = 8'h00;

end
endmodule
