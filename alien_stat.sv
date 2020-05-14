/*
	This status array will account for each of the 7 aliens in each row. If a hit is detected frome
	the projectile module, the module will check if that alien has already been hit. If so, nothing happens.
	If the alien was hit and still exists, the alien is set to 0, and the projectile will be reset.
*/
module stat_array(input Clk, Reset,
						input [6:0] hit,
						input [2:0] curr_state,
						input [9:0] proj_y,
						output [6:0] row,
						output point
);

	always_ff @ (posedge Clk)
	begin
		if(Reset || curr_state == 3'd0 || curr_state == 3'd5 || curr_state == 3'd6) begin
			row <= 7'b1111111;
			point <= 1'b0;
		end
		
		else if(hit > 7'd0) begin
			if(hit[6] && row[6]) begin
				row[6] <= 1'b0;
				point <= 1'b1;
			end
			else if (hit[5] && row[5]) begin
				row[5] <= 1'b0;
				point <= 1'b1;
			end
			else if (hit[4] && row[4]) begin
				row[4] <= 1'b0;
				point <= 1'b1;
			end
			else if (hit[3] && row[3]) begin
				row[3] <= 1'b0;
				point <= 1'b1;
			end
			else if (hit[2] && row[2]) begin
				row[2] <= 1'b0;				
				point <= 1'b1;
			end
			else if (hit[1] && row[1]) begin
				row[1] <= 1'b0;
				point <= 1'b1;
			end
			else if (hit[0] && row[0]) begin
				row[0] <= 1'b0;
				point <= 1'b1;
			end
			else begin
				row <= row;
				point <= point;
			end
		end
		
		else if (proj_y < 10'd420)
		begin
			row <= row;
			point <= point;
		end
		else
		begin
			row <= row;
			point <= 1'b0;
		end
	
	end
endmodule




//module stat_array(input Clk,
//						input logic [9:0] proj_x, proj_y, // coordinates of the projectile
//						input [9:0] alien_x, alien_y, alienb_x, alienb_y, alienc_x, alienc_y, // coordinates of the alien rows
//						input [2:0] curr_state,
//						output logic hit, 	// the projectile has hit something and should be destroyed
////										 stat_0, stat_1, stat_2, stat_3, stat_4, stat_5, stat_6,
////										 statb_0, statb_1, statb_2, statb_3, statb_4, statb_5, statb_6,
//										 statc_0, statc_1, statc_2, statc_3, statc_4, statc_5, statc_6,
//										 
//										 all_stat1, all_stat2, all_stat3	// represents if all aliens have been destroyed in the row
//);
//	/* Alien alive - 1, Alien defeated - 0
//	  if an alien overlaps with the projectile and currently is "alive", it's status will go to 0. This status will
//	  be sent to the colormapper and determine if the alien should show up or not.
//	  
//	  Alien status will also be sent to the game_state module to determine if the player "Wins" or has reached "Game Over"
//	  
//	  Will also be connected to Score keeper
//	  
//	  wave_size_x = 201
//	  shape_size_x = 21;
//	  shape_size_y = 16;
//	  shape_space = 9;
//	*/
//	
//	logic [6:0] row_1 = 7'b1111111;
//	logic [6:0] row_2 = 7'b1111111;
//	logic [6:0] row_3 = 7'b1111111;
//	logic collision = 1'b0;
//	
//	always_comb
//	begin
//	// start with the bottom row of aliens
//		row_3 = row_3 && 7'b1111111; collision = 1'b0;
//		
//		if(proj_x >= alienc_x && proj_x < alienc_x + 10'd201  && proj_y <= alienc_y + 10'd16)
//		begin
//			if(row_3[6] && proj_x >= alienc_x && proj_x < alienc_x + 10'd21)	
//			begin
//				collision = 1'b1;
//				row_3[6] = 1'b0;
//			end
//			
//			else if(row_3[5] && proj_x >= alienc_x + 10'd30 && proj_x < alienc_x + 10'd51)	
//			begin
//				collision = 1'b1;
//				row_3[5] = 1'b0;
//			end
//			
//			else if(row_3[4] && proj_x >= alienc_x + 10'd60 && proj_x < alienc_x + 10'd81)	
//			begin
//				collision = 1'b1;
//				row_3[4] = 1'b0;
//			end
//			
//			else if(row_3[3] && proj_x >= alienc_x + 10'd90 && proj_x < alienc_x + 10'd111)	
//			begin
//				collision = 1'b1;
//				row_3[3] = 1'b0;
//			end
//			
//			else if(row_3[2] && proj_x >= alienc_x + 10'd120 && proj_x < alienc_x + 10'd141)	
//			begin
//				collision = 1'b1;
//				row_3[2] = 1'b0;
//			end
//			
//			else if(row_3[1] && proj_x >= alienc_x + 10'd150 && proj_x < alienc_x + 10'd171)	
//			begin
//				collision = 1'b1;
//				row_3[1] = 1'b0;
//			end
//			
//			else if(row_3[0] && proj_x >= alienc_x + 10'd180 && proj_x < alienc_x + 10'd201)	
//			begin
//				collision = 1'b1;
//				row_3[0] = 1'b0;
//			end
//			
//			else
//			begin
//				collision = 1'b0;
//			end
//			//row_3 = row_3; collision = collision;
//		end
//		//row_3 = row_3; collision = collision;
//		
////		// test if entire row is dead
////		if (statc_0 && statc_1 && statc_2 && statc_3 && statc_4 && statc_5 && statc_6 == 1'b0)
////			all_stat3 = 1'b1;
//	end
//	assign hit = collision;
//	assign statc_0 = row_3[6]; assign statc_1 = row_3[5]; assign statc_2 = row_3[4]; assign statc_3 = row_3[3];
//	assign statc_4 = row_3[2]; assign statc_5 = row_3[1]; assign statc_6 = row_3[0];
//endmodule