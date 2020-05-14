/*
	Determines the colors that should be displayed on the screen.
	Game States
	START:
		Display the gradient background and black game area with "START!" displayed in the middle of the screen.
	Play:
		Display the gradient background and black game area. "SCORE: _ _ _" is in the top left corner. The moving aliens 
		the player's ship will be confined to the game area.
	Win:
		The player's ship will be displayed wherever it was when the game was won. "YOU WIN!" is displayed in the middle of
		the screen. The gradient background will flash different colors.
	Game_Over:
		The aliens and player's ship will be stopped wherever they were when the game was lost. "GAME OVER" is displayed in
		the middle of the screen. The player's ship will turn a light red hue.
	PAUSE/PAUSE2/Hold:
		The aliens and player's ship will be stopped wherever they were when the game was paused. "PAUSE" is displayed in
		the middle of the screen.

*/

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_me, is_alien, is_alienb, is_alienc, is_proj,   // Whether current pixel belongs to a special figure 
														alien_0, alien_1, alien_2, alien_3, alien_4, alien_5, alien_6, 
														alienb_0, alienb_1, alienb_2, alienb_3, alienb_4, alienb_5, alienb_6, 
														alienc_0, alienc_1, alienc_2, alienc_3, alienc_4, alienc_5, alienc_6,
							 //input logic offset,							
							 input logic [6:0] rowc, rowb, row, 	  // the status of each row of aliens
							 input logic [7:0] winR, winG, winB, 	  // defines the color of the screen in the "WIN" state
                                                              //   or background (computed in ball.sv)
							 input logic  [2:0] curr_state,			  // currrent gameplay state (Start, Play, Win, Game Over)
							  
							 // addresses for accessing the font rom
							 input			[10:0] sprite_addr, score_address, start_addr, over_addr, win_addr, pause_addr,
							 input logic [23:0] colors_A, 			  // output from the alien RAM colors
							 
							 // addresses for accessing the sprite rom
							 input logic [8:0] alien_addr, ship_addrW, ship_addrR, ship_addrB,
                      input        [9:0] DrawX, DrawY, ship_x, alien_x,       // Current pixel coordinates
							 
                      output logic [7:0] VGA_R, VGA_G, VGA_B  // VGA RGB output

                     );
    
    logic [7:0] Red, Green, Blue, font_data, start_data, over_data, win_data, pause_data;
	logic [23:0] ship_dataW, ship_dataR, ship_dataB;
	logic [20:0] alien_data;

    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// DATA FROM THE FONT_ROM AND SPRITE_ROM
font_rom font(.addr(score_address), .data(font_data));
font_rom start(.addr(start_addr), .data(start_data));
font_rom over(.addr(over_addr), .data(over_data));
font_rom win(.addr(win_addr), .data(win_data));
font_rom pause(.addr(pause_addr), .data(pause_data));

//alien_rom ALIENDIEDIEDIE(.addr(alien_addr), .data(alien_data));

sprite_rom white_ship(.addr(ship_addrW), .data(ship_dataW));
sprite_rom red_ship(.addr(ship_addrR), .data(ship_dataR));
sprite_rom blue_ship(.addr(ship_addrB), .data(ship_dataB));
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Assign color based on is_ball signal
    always_comb
    begin
	 // draw the "START" screen
	 if(curr_state == 3'd0)
	 begin
		//S
		if(DrawX >= 10'd300 && DrawX < 10'd308 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd307 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//T
		else if((DrawX >= 10'd308 && DrawX < 10'd316 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd315 - DrawX]) 
				|| (DrawX >=10'd332 && DrawX < 10'd340 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd339 - DrawX])) 
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//A
		else if(DrawX >= 10'd316 && DrawX < 10'd324 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd323 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//R
		else if(DrawX >= 10'd324 && DrawX < 10'd332 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd331 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//!
		else if(DrawX >=10'd340 && DrawX < 10'd348 && DrawY >= 10'd231 && DrawY < 10'd247 && start_data[10'd347 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		else 
        begin
			  if(DrawX >= 10'd165 && DrawX < 10'd483)
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
			  else
			  begin
					// Background with nice color gradient
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
				end
        end
	 end
	 
	 // draw the "WIN" screen
	 else if(curr_state == 3'd4)
	 begin
			//Y
			if(DrawX >= 10'd292 && DrawX < 10'd300 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd299 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			//O
			else if(DrawX >= 10'd300 && DrawX < 10'd308 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd307 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			//U
			else if(DrawX >= 10'd308 && DrawX < 10'd316 && win_data[10'd315 - DrawX] && DrawY >= 10'd231 && DrawY < 10'd247)
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//W
			else if(DrawX >= 10'd324 && DrawX < 10'd332 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd331 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//I
			else if(DrawX >= 10'd332 && DrawX < 10'd340 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd339 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//N
			else if(DrawX >= 10'd340 && DrawX < 10'd348 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd347 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			// !
			else if(DrawX >= 10'd348 && DrawX < 10'd356 && DrawY >= 10'd231 && DrawY < 10'd247 && win_data[10'd355 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
//			else 
//        begin
//			  if(DrawX >= 10'd165 && DrawX < 10'd483)
//			  begin
//					Red = 8'h00; 
//					Green = 8'h00;
//					Blue = 8'h00;
//			  end
//			  else
//			  begin
//					// Background with nice color gradient
//					Red = 8'h3f; 
//					Green = 8'h00;
//					Blue = 8'h7f - {1'b0, DrawX[9:3]};
//				end
//        end
		  // ship
        else if (is_me == 1'b1)
        begin
			if(ship_dataW[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			else if(ship_dataR[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
			end
			else if(ship_dataB[DrawX-ship_x])
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
			end
			else
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue =8'h00;
			end
        end
		  
		  else if (is_proj == 1'b1)
        begin
				Red = 8'hff;
				Green = 8'hff;
				Blue =8'hff;
			end
		  
//// SCORE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// S
		  else if (DrawX >= 10'd0 && DrawX < 10'd8 && DrawY < 10'd16 && font_data[10'd7 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// C
		  else if (DrawX >= 10'd8 && DrawX < 10'd16 && DrawY < 10'd16 && font_data[10'd15 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// O
		  else if (DrawX >= 10'd16 && DrawX < 10'd24 && DrawY < 10'd16 && font_data[10'd23 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// R
		  else if (DrawX >= 10'd24 && DrawX < 10'd32 && DrawY < 10'd16 && font_data[10'd31 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// E
		  else if (DrawX >= 10'd32 && DrawX < 10'd40 && DrawY < 10'd16 && font_data[10'd39 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// :
		  else if (DrawX >= 10'd40 && DrawX < 10'd48 && DrawY < 10'd16 && font_data[10'd47 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		  		  // hundreds place
		else if(DrawX >= 10'd52 && DrawX < 10'd60 && DrawY < 10'd16 && font_data[10'd59 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// tens place
		else if(DrawX >= 10'd60 && DrawX < 10'd68 && DrawY < 10'd16 && font_data[10'd67 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// ones place
		else if(DrawX >= 10'd68 && DrawX < 10'd76 && DrawY < 10'd16 && font_data[10'd75 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end

// BACKGROUND DATA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		  else 
        begin
			  if(DrawX >= 10'd165 && DrawX < 10'd483)
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
			  else
			  begin
					Red = winR; 
					Green = winG;
					Blue = winB;// - {1'b0, DrawX[9:3]};
					// Background with nice color gradient
//					Red = 8'h3f; 
//					Green = 8'h00;
//					Blue = 8'h7f - {1'b0, DrawX[9:3]};
				end
        end
	 
	 end
	 
	 // draw the "Game Over" screen
	else if(curr_state == 3'b001)
	begin
			//G
			if (DrawX >= 10'd284 && DrawX < 10'd292 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd291 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			//A
			else if(DrawX >= 10'd292 && DrawX < 10'd300 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd299 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			//M
			else if(DrawX >= 10'd300 && DrawX < 10'd308 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd307 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
			//E
			else if((DrawX >= 10'd308 && DrawX < 10'd316 && over_data[10'd315 - DrawX] || DrawX >= 10'd340 && DrawX < 10'd348 && over_data[10'd347 - DrawX]) && DrawY >= 10'd231 && DrawY < 10'd247)
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//O
			else if(DrawX >= 10'd324 && DrawX < 10'd332 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd331 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//V
			else if(DrawX >= 10'd332 && DrawX < 10'd340 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd339 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//R
			else if(DrawX >= 10'd348 && DrawX < 10'd356 && DrawY >= 10'd231 && DrawY < 10'd247 && over_data[10'd355 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
//			else 
//        begin
//			  if(DrawX >= 10'd165 && DrawX < 10'd483)
//			  begin
//					Red = 8'h00; 
//					Green = 8'h00;
//					Blue = 8'h00;
//			  end
//			  else
//			  begin
//					// Background with nice color gradient
//					Red = 8'h3f; 
//					Green = 8'h00;
//					Blue = 8'h7f - {1'b0, DrawX[9:3]};
//				end
//        end
		  else if (is_me == 1'b1)
        begin
			if(ship_dataW[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'h72;
				Blue = 8'h6f;
			end
			else if(ship_dataR[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
			end
			else if(ship_dataB[DrawX-ship_x])
			begin
				Red = 8'h2f;
				Green = 8'h00;
				Blue = 8'hff;
			end
			else
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue =8'h00;
			end
        end
		  
		  else if (is_proj == 1'b1)
        begin
				Red = 8'hff;
				Green = 8'hff;
				Blue =8'hff;
			end
					  // aliens
		  else if (is_alien  == 1'b1 && ((alien_0 && row[6]) || (alien_1 && row[5])|| (alien_2 && row[4]) || 
						(alien_3 && row[3]) || (alien_4 && row[2]) || (alien_5 && row[1]) || (alien_6 && row[0])))// && alien_data[DrawX - alien_x] && (alien_0 || alien_1 || alien_2 || alien_3 || alien_4 || alien_5 || alien_6 || alien_7))
        begin
				  Red = colors_A[23:16]; 
				  Green = colors_A[15:8];
              Blue = colors_A[7:0];
				  
        end
			else if (is_alienb == 1'b1 && ((alienb_0 && rowb[6]) || (alienb_1 && rowb[5])|| (alienb_2 && rowb[4]) || 
						(alienb_3 && rowb[3]) || (alienb_4 && rowb[2]) || (alienb_5 && rowb[1]) || (alienb_6 && rowb[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'h40;
					Green = 8'he0;
					Blue = 8'hd0;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
			else if (is_alienc == 1'b1 && ((alienc_0 && rowc[6]) || (alienc_1 && rowc[5])|| (alienc_2 && rowc[4]) || 
						(alienc_3 && rowc[3]) || (alienc_4 && rowc[2]) || (alienc_5 && rowc[1]) || (alienc_6 && rowc[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'hdb;
					Green = 8'h70;
					Blue = 8'h93;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
		  
//// SCORE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// S
		  else if (DrawX >= 10'd0 && DrawX < 10'd8 && DrawY < 10'd16 && font_data[10'd7 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// C
		  else if (DrawX >= 10'd8 && DrawX < 10'd16 && DrawY < 10'd16 && font_data[10'd15 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// O
		  else if (DrawX >= 10'd16 && DrawX < 10'd24 && DrawY < 10'd16 && font_data[10'd23 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// R
		  else if (DrawX >= 10'd24 && DrawX < 10'd32 && DrawY < 10'd16 && font_data[10'd31 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// E
		  else if (DrawX >= 10'd32 && DrawX < 10'd40 && DrawY < 10'd16 && font_data[10'd39 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// :
		  else if (DrawX >= 10'd40 && DrawX < 10'd48 && DrawY < 10'd16 && font_data[10'd47 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		  		  // hundreds place
		else if(DrawX >= 10'd52 && DrawX < 10'd60 && DrawY < 10'd16 && font_data[10'd59 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// tens place
		else if(DrawX >= 10'd60 && DrawX < 10'd68 && DrawY < 10'd16 && font_data[10'd67 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// ones place
		else if(DrawX >= 10'd68 && DrawX < 10'd76 && DrawY < 10'd16 && font_data[10'd75 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end

// BACKGROUND DATA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		  else 
        begin
			  if(DrawX >= 10'd165 && DrawX < 10'd483)
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
			  else
			  begin
					// Background with nice color gradient
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
				end
        end
		end
		 // draw the "Pause" screen
	else if(curr_state == 3'b010)
	begin
			//P
		if(DrawX >= 10'd300 && DrawX < 10'd308 && DrawY >= 10'd231 && DrawY < 10'd247 && pause_data[10'd307 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//A
		else if((DrawX >= 10'd308 && DrawX < 10'd316 && DrawY >= 10'd231 && DrawY < 10'd247 && pause_data[10'd315 - DrawX])) 
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//U
		else if(DrawX >= 10'd316 && DrawX < 10'd324 && DrawY >= 10'd231 && DrawY < 10'd247 && pause_data[10'd323 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//S
		else if(DrawX >= 10'd324 && DrawX < 10'd332 && DrawY >= 10'd231 && DrawY < 10'd247 && pause_data[10'd331 - DrawX])
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
		//E
		else if(| (DrawX >=10'd332 && DrawX < 10'd340 && DrawY >= 10'd231 && DrawY < 10'd247 && pause_data[10'd339 - DrawX]))
				begin
					Red = 8'hff;
					Green = 8'hff;
					Blue = 8'hff;
				end
//			else 
//        begin
//			  if(DrawX >= 10'd165 && DrawX < 10'd483)
//			  begin
//					Red = 8'h00; 
//					Green = 8'h00;
//					Blue = 8'h00;
//			  end
//			  else
//			  begin
//					// Background with nice color gradient
//					Red = 8'h3f; 
//					Green = 8'h00;
//					Blue = 8'h7f - {1'b0, DrawX[9:3]};
//				end
//        end
		  else if (is_me == 1'b1)
        begin
			if(ship_dataW[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			else if(ship_dataR[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
			end
			else if(ship_dataB[DrawX-ship_x])
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
			end
			else
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue =8'h00;
			end
        end
		  
		  else if (is_proj == 1'b1)
        begin
				Red = 8'hff;
				Green = 8'hff;
				Blue =8'hff;
			end
					  // aliens
		  else if (is_alien  == 1'b1 && ((alien_0 && row[6]) || (alien_1 && row[5])|| (alien_2 && row[4]) || 
						(alien_3 && row[3]) || (alien_4 && row[2]) || (alien_5 && row[1]) || (alien_6 && row[0])))// && alien_data[DrawX - alien_x] && (alien_0 || alien_1 || alien_2 || alien_3 || alien_4 || alien_5 || alien_6 || alien_7))
        begin
				  Red = colors_A[23:16]; 
				  Green = colors_A[15:8];
              Blue = colors_A[7:0];
				  
        end
			else if (is_alienb == 1'b1 && ((alienb_0 && rowb[6]) || (alienb_1 && rowb[5])|| (alienb_2 && rowb[4]) || 
						(alienb_3 && rowb[3]) || (alienb_4 && rowb[2]) || (alienb_5 && rowb[1]) || (alienb_6 && rowb[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'h40;
					Green = 8'he0;
					Blue = 8'hd0;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
			else if (is_alienc == 1'b1 && ((alienc_0 && rowc[6]) || (alienc_1 && rowc[5])|| (alienc_2 && rowc[4]) || 
						(alienc_3 && rowc[3]) || (alienc_4 && rowc[2]) || (alienc_5 && rowc[1]) || (alienc_6 && rowc[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'hdb;
					Green = 8'h70;
					Blue = 8'h93;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
		  
//// SCORE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// S
		  else if (DrawX >= 10'd0 && DrawX < 10'd8 && DrawY < 10'd16 && font_data[10'd7 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// C
		  else if (DrawX >= 10'd8 && DrawX < 10'd16 && DrawY < 10'd16 && font_data[10'd15 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// O
		  else if (DrawX >= 10'd16 && DrawX < 10'd24 && DrawY < 10'd16 && font_data[10'd23 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// R
		  else if (DrawX >= 10'd24 && DrawX < 10'd32 && DrawY < 10'd16 && font_data[10'd31 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// E
		  else if (DrawX >= 10'd32 && DrawX < 10'd40 && DrawY < 10'd16 && font_data[10'd39 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// :
		  else if (DrawX >= 10'd40 && DrawX < 10'd48 && DrawY < 10'd16 && font_data[10'd47 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		  		  // hundreds place
		else if(DrawX >= 10'd52 && DrawX < 10'd60 && DrawY < 10'd16 && font_data[10'd59 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// tens place
		else if(DrawX >= 10'd60 && DrawX < 10'd68 && DrawY < 10'd16 && font_data[10'd67 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// ones place
		else if(DrawX >= 10'd68 && DrawX < 10'd76 && DrawY < 10'd16 && font_data[10'd75 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end

// BACKGROUND DATA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		  else 
        begin
			  if(DrawX >= 10'd165 && DrawX < 10'd483)
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
			  else
			  begin
					// Background with nice color gradient
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
				end
        end
		end
		
		else
		begin
		  // ship
        if (is_me == 1'b1)
        begin
			if(ship_dataW[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'hff;
				Blue = 8'hff;
			end
			else if(ship_dataR[DrawX-ship_x])
			begin
				Red = 8'hff;
				Green = 8'h00;
				Blue = 8'h00;
			end
			else if(ship_dataB[DrawX-ship_x])
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'hff;
			end
			else
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue =8'h00;
			end
        end
		  
		  else if (is_proj == 1'b1)
        begin
				Red = 8'hff;
				Green = 8'hff;
				Blue =8'hff;
			end
		  
		  // aliens
		  else if (is_alien  == 1'b1 && ((alien_0 && row[6]) || (alien_1 && row[5])|| (alien_2 && row[4]) || 
						(alien_3 && row[3]) || (alien_4 && row[2]) || (alien_5 && row[1]) || (alien_6 && row[0])))// && alien_data[DrawX - alien_x] && (alien_0 || alien_1 || alien_2 || alien_3 || alien_4 || alien_5 || alien_6 || alien_7))
        begin
				  Red = colors_A[23:16]; 
				  Green = colors_A[15:8];
              Blue = colors_A[7:0];
				  
        end
			else if (is_alienb == 1'b1 && ((alienb_0 && rowb[6]) || (alienb_1 && rowb[5])|| (alienb_2 && rowb[4]) || 
						(alienb_3 && rowb[3]) || (alienb_4 && rowb[2]) || (alienb_5 && rowb[1]) || (alienb_6 && rowb[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'h40;
					Green = 8'he0;
					Blue = 8'hd0;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
			else if (is_alienc == 1'b1 && ((alienc_0 && rowc[6]) || (alienc_1 && rowc[5])|| (alienc_2 && rowc[4]) || 
						(alienc_3 && rowc[3]) || (alienc_4 && rowc[2]) || (alienc_5 && rowc[1]) || (alienc_6 && rowc[0])))
			begin
				if(colors_A > 0)
				begin
					Red = 8'hdb;
					Green = 8'h70;
					Blue = 8'h93;
				end
				else
				begin
					Red = colors_A[23:16]; 
				   Green = colors_A[15:8];
               Blue = colors_A[7:0];
				 end
			end
//// SCORE ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// S
		  else if (DrawX >= 10'd0 && DrawX < 10'd8 && DrawY < 10'd16 && font_data[10'd7 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// C
		  else if (DrawX >= 10'd8 && DrawX < 10'd16 && DrawY < 10'd16 && font_data[10'd15 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// O
		  else if (DrawX >= 10'd16 && DrawX < 10'd24 && DrawY < 10'd16 && font_data[10'd23 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// R
		  else if (DrawX >= 10'd24 && DrawX < 10'd32 && DrawY < 10'd16 && font_data[10'd31 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// E
		  else if (DrawX >= 10'd32 && DrawX < 10'd40 && DrawY < 10'd16 && font_data[10'd39 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
// :
		  else if (DrawX >= 10'd40 && DrawX < 10'd48 && DrawY < 10'd16 && font_data[10'd47 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		  // hundreds place
		else if(DrawX >= 10'd52 && DrawX < 10'd60 && DrawY < 10'd16 && font_data[10'd59 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// tens place
		else if(DrawX >= 10'd60 && DrawX < 10'd68 && DrawY < 10'd16 && font_data[10'd67 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end
		// ones place
		else if(DrawX >= 10'd68 && DrawX < 10'd76 && DrawY < 10'd16 && font_data[10'd75 - DrawX])
        begin

				  Red = 8'hff; 
				  Green = 8'hff;
              Blue = 8'hff;
				  
        end

// BACKGROUND DATA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		  else 
        begin
			  if(DrawX >= 10'd165 && DrawX < 10'd483)
			  begin
					Red = 8'h00; 
					Green = 8'h00;
					Blue = 8'h00;
			  end
			  else
			  begin
					// Background with nice color gradient
					Red = 8'h3f; 
					Green = 8'h00;
					Blue = 8'h7f - {1'b0, DrawX[9:3]};
				end
        end

 
	 end
    end 
    
endmodule
