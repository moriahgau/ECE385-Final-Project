/*
	This module controls the game state. The game has 7 unqiue states
	START: 
		This is the initial state of the game. The game will start when 'tab' is pressed.
	HOLD2:
		This is a transition state between START/Win/Game_Over and Play.
	Play:
		This is the state where the majority of the game occurs. If 'Q' is pressed, the game will enter the 
		Pause states. If the game is won or lost, the appropriate transition will occur from here.
	Win:
		If the game was won, this state will be entered. If 'tab' is pressed, the game can be played again.
	Game_Over:
		If the game is lost, this state will be entered. If 'tab' is pressed, the game can be played again.
	Pause:
		This state is entered if the game is paused. Upon release of 'Q', Pause2 will be entered.
	Pause2:
		This is the second pause state. If 'Q' is pressed, the HOLD state will be entered.
	HOLD:
		This is the third pause state. When 'Q' is released, the Play state will be entered and the game resumed.
	
*/
module game_state(	input	 logic Clk,
							input  logic Reset,
							input logic [7:0] keycode,
							input logic win, lose,
							
							output logic [2:0] curr_state
);
// various gameplay states
// State Codes:	000	 001		   010	 			011   100  101   110
enum logic [2:0] {Start, Game_Over, Pause, Pause2, Play, Win, HOLD, HOLD2} state, next_state;	
logic [7:0] Q = 8'h14;
logic [7:0] tab = 8'h2b;

always_ff @ (posedge Clk)
begin
	if (Reset) 
	begin
	//	state <= Play;
		state <= Start;

	end
		
	else 
	begin
		state <= next_state;

	end
end

// NEXT STATE LOGIC AND STATE BEHAVIOR
always_comb
begin
	// set defaults
	next_state = state;
	curr_state = 3'd0;
	
	// assign next state
	unique case (state)
		Start:
		begin
			curr_state = 3'd0;
		// start the game when 'tab' is pressed
			if(keycode == tab)
				next_state = HOLD2;
			else
				next_state = Start;
		end	
		Game_Over:
		begin
			curr_state = 3'd1;
		// play again if 'tab' is pressed
			if(keycode == tab)
				next_state = HOLD2;	
			else
				next_state = Game_Over;
		end
		
		Play:
		begin
			curr_state = 3'd3;
			if(win)
				next_state = Win;
			else if (lose)
				next_state = Game_Over;
			else if(keycode == Q)	// pause the game when 'Q' is pressed
			begin
				next_state = Pause;
	
			end
			else
				next_state = Play;
		end
		
		Win:
		begin
			curr_state = 3'd4;
			if(keycode == tab)
				next_state = HOLD2;	
			else
				next_state = Win;
		end
		
		Pause:
		begin
			curr_state = 3'd2;
			if(keycode == Q)		// Unpause when 'Q' is pressed
				next_state = Pause;	
			else
				next_state = Pause2;
		end
		
		Pause2:
		begin
			curr_state = 3'd2;
			if(keycode == Q)		// Unpause when 'Q' is pressed
				next_state = HOLD;	
			else
				next_state = Pause2;
		end
			
		HOLD:
		begin
			curr_state = 3'd2;
			if(keycode == Q)		// Unpause when 'Q' is pressed
				next_state = HOLD;	
			else
				next_state = Play;

		end
		
		HOLD2:
		begin
			curr_state = 3'd6;
			next_state = Play;
		end
	endcase
end

endmodule
