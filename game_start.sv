/*
	This module contains the address calculations for characters in the font_rom for each "interesting" state
	START:
		"START!"
	Win:	
		"YOU WIN!"
	Game Over:
		"GAME OVER"
	PAUSE
		"PAUSE"
	The words will be written to the center of the screen.
*/

module game_start( 
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic[10:0] start_addr           // Whether current pixel belongs to Rect or background
);



// START from 300-340
always_comb
begin
start_addr = 0;
//S
if(DrawX >= 10'd300 && DrawX < 10'd308)
	start_addr = (DrawY - 10'd231) + 16*'h017;
//T
else if(DrawX >= 10'd308 && DrawX < 10'd316 || DrawX >=10'd332 && DrawX < 10'd340)
	start_addr = (DrawY - 10'd231) + 16*'h018;
//A
else if(DrawX >= 10'd316 && DrawX < 10'd324)
	start_addr = (DrawY - 10'd231) + 16*'h00c;
//R
else if(DrawX >= 10'd324 && DrawX < 10'd332)
	start_addr = (DrawY - 10'd231) + 16*'h016;
//!
else
	start_addr = (DrawY - 10'd231) + 16*'h00a;
	
end

endmodule

module game_over(
				input[9:0] DrawX, DrawY,
				output logic[10:0] over_addr);

// GAME OVER from 284 - 356
always_comb
begin
over_addr = 0;

//G
if(DrawX >= 10'd284 && DrawX < 10'd292)
	over_addr = (DrawY - 10'd231) + 16*'h00f;
//A
else if(DrawX >= 10'd292 && DrawX < 10'd300)
	over_addr = (DrawY - 10'd231) + 16*'h00c;
//M
else if(DrawX >= 10'd300 && DrawX < 10'd308)
	over_addr = (DrawY - 10'd231) + 16*'h012;
//E
else if(DrawX >= 10'd308 && DrawX < 10'd316 || DrawX >= 10'd340 && DrawX < 10'd348)
	over_addr = (DrawY - 10'd231) + 16*'h00e;
//O
else if(DrawX >= 10'd324 && DrawX < 10'd332)
	over_addr = (DrawY - 10'd231) + 16*'h014;
//V
else if(DrawX >= 10'd332 && DrawX < 10'd340)
	over_addr = (DrawY - 10'd231) + 16*'h01a;
//R
else if(DrawX >= 10'd348 && DrawX < 10'd356)
	over_addr = (DrawY - 10'd231) + 16*'h016;
else
	over_addr = (DrawY - 10'd231) + 16*'h00a;
	
end

endmodule

module game_win(
				input[9:0] DrawX, DrawY,
				output logic[10:0] win_addr);

// GAME OVER from 284 - 356
always_comb
begin
win_addr = 0;

//Y
if(DrawX >= 10'd292 && DrawX < 10'd300)
	win_addr = (DrawY - 10'd231) + 16*'h01c;
//O
else if(DrawX >= 10'd300 && DrawX < 10'd308)
	win_addr = (DrawY - 10'd231) + 16*'h014;
//U
else if(DrawX >= 10'd308 && DrawX < 10'd316)
	win_addr = (DrawY - 10'd231) + 16*'h019;
//W
else if(DrawX >= 10'd324 && DrawX < 10'd332)
	win_addr = (DrawY - 10'd231) + 16*'h01b;
//I
else if(DrawX >= 10'd332 && DrawX < 10'd340)
	win_addr = (DrawY - 10'd231) + 16*'h010;
//N
else if(DrawX >= 10'd340 && DrawX < 10'd348)
	win_addr = (DrawY - 10'd231) + 16*'h013;
	
else if(DrawX >= 10'd348 && DrawX < 10'd356)
	win_addr = (DrawY - 10'd231) + 16*'h00a;
	
end

endmodule

module game_pause( 
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               output logic[10:0] pause_addr           // Whether current pixel belongs to Rect or background
);



	// Pause from 300-340
	always_comb
	begin
	pause_addr = 0;
	//P
	if(DrawX >= 10'd300 && DrawX < 10'd308)
		pause_addr = (DrawY - 10'd231) + 16*'h015;
	//A
	else if(DrawX >= 10'd308 && DrawX < 10'd316)
		pause_addr = (DrawY - 10'd231) + 16*'h00c;
	//U
	else if(DrawX >= 10'd316 && DrawX < 10'd324)
		pause_addr = (DrawY - 10'd231) + 16*'h019;
	//S
	else if(DrawX >= 10'd324 && DrawX < 10'd332)
		pause_addr = (DrawY - 10'd231) + 16*'h017;
	//E
	else if(DrawX >=10'd332 && DrawX < 10'd340)
		pause_addr = (DrawY - 10'd231) + 16*'h00e;
		
	end

endmodule