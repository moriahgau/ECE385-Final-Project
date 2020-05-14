/*
	This module defines the behavior of the projectile that will be shot by the player towards the aliens. 
	In the play state, if 'F' is pressed, the projectile/laser will be fired and move upward. This module
	also contains the logic for collision detection. When the coordinates of the projectile interesect the
	coordinates of an alien, it should be reset so it can be fired again. Additionally, the hit is exported
	and used to update the status array for each alien row.
*/

module  projectile ( input   Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [9:0]   ship_x,   // position of the ship
					input [9:0]   alienc_x, alienc_y, // position of the bottom alien row
									  alienb_x, alienb_y,
									  alien_x, alien_y,
					input [2:0] curr_state,
					input [7:0]   keycode,
					input [6:0]   row, rowb, rowc, 		// keep track of which aliens are alive
					
					output [6:0] hit, hitb, hitc,
					output [9:0] proj_x, proj_y,
					output [9:0] fire_count,
					output logic is_proj
              );
    
    // the ship is at Y = 420
    parameter [9:0] Rect_X_Min = 10'd169;       // Leftmost point on the X axis
    parameter [9:0] Rect_X_Max = 10'd479;     // Rightmost point on the X axis
	 parameter [9:0] Rect_Y_Min = 10'd0;
    parameter [9:0] Rect_Y_Max = 10'd425;     // Bottommost point on the Y axiss

    parameter [9:0] Rect_Y_Step = 10'd10;      // Step size on the Y axis
   
    parameter [9:0] Rect_X_Size = 10'd1;        // Rect size
	 parameter [9:0] Rect_Y_Size = 10'd10;
    
    logic [9:0] Rect_X_Pos, Rect_X_Motion, Rect_Y_Pos, Rect_Y_Motion;
	 logic [9:0] Rect_X_Pos_in, Rect_X_Motion_in, Rect_Y_Pos_in, Rect_Y_Motion_in;
	 
	 
	 logic [7:0] fire = 8'h09;
	 logic shots;
	logic reset; // flag if the projectile has hit
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || curr_state == 3'd0)
        begin
            Rect_X_Pos <= ship_x;
            Rect_Y_Pos <= Rect_Y_Max;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
				fire_count <= 10'd0;
        end
        else
        begin
            Rect_X_Pos <= Rect_X_Pos_in;
            Rect_Y_Pos <= Rect_Y_Pos_in;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
				fire_count <= fire_count + shots;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

	  always_comb
    begin
        // By default, keep motion and position unchanged
        Rect_X_Pos_in = Rect_X_Pos;
        Rect_Y_Pos_in = Rect_Y_Pos;
        Rect_X_Motion_in = Rect_X_Motion;
        Rect_Y_Motion_in = Rect_Y_Motion;
		  shots = 1'b0;
		  
		  // reset the projectile if an alien has been hit
			if(Rect_Y_Pos <= 10'd8 || reset)
			begin
				Rect_Y_Pos_in = 10'd420;
				Rect_Y_Motion_in = 10'd0;
			end
	
// Update position and motion of ship only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
					
				// Keypress handling
				if(keycode == fire && Rect_Y_Pos >= 10'd420 && curr_state == 3'd3)
				begin
					Rect_Y_Motion_in = (~Rect_Y_Step) + 10'd1;
					Rect_X_Pos_in = ship_x + 10'd13;
					shots = 1'b1;
					// Update the Rect's position with its motion
					Rect_Y_Pos_in = Rect_Y_Pos + Rect_Y_Motion;
					if(Rect_Y_Pos <= 10'd8 || reset)
					begin
						Rect_Y_Pos_in = 10'd420;
						Rect_Y_Motion_in = 10'd0;
					end
	
					
				end				
				
				else
				begin
					if(Rect_Y_Pos <= 10'd8 || reset)
						begin
						
						Rect_Y_Pos_in = 10'd420;
						Rect_Y_Motion_in = 10'd0;
						end
					else
					begin
						Rect_Y_Motion_in = Rect_Y_Motion;
						// Update the Rect's position with its motion
						Rect_Y_Pos_in = Rect_Y_Pos + Rect_Y_Motion;
					end
				end
				
		// Boundary condition if the projectile reaches the top of the screen		
				if(Rect_Y_Pos <= 10'd8 || reset)
					begin
					Rect_Y_Pos_in = 10'd420;
					Rect_Y_Motion_in = 10'd0;
					end

        end

		end
// determine if the VGA is drawing the projectile or not

	always_comb
	 begin
		reset = 1'b0;
		if(Rect_Y_Pos >= 10'd420)
		begin
			is_proj = 1'b0;
		end
		
		if(DrawX>= Rect_X_Pos && DrawX < Rect_X_Pos + Rect_X_Size && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + Rect_Y_Size)
		begin
				hit = 7'b0;
				hitb = 7'b0;
				hitc = 7'b0;
				is_proj = 1'b1;
			if(Rect_Y_Pos >= 10'd420)
			begin
				is_proj = 1'b0;
			end

// determine if the projectile has collided with an alien in the bottom row
			if(is_proj && Rect_Y_Pos <= alien_y + 10'd16 && Rect_Y_Pos > alien_y)
			begin
				hitc = 7'b0; hitb = 7'b0;
				if (row[6] && Rect_X_Pos >= alien_x && Rect_X_Pos < alien_x + 10'd21)
					begin
						is_proj = 1'b0;
						hit = 7'b1000000;
						reset = 1'b1;
					end
					
					else if (row[5] && Rect_X_Pos >= alien_x + 10'd30 && Rect_X_Pos < alien_x + 10'd51)
					begin
						is_proj = 1'b0;
						hit = 7'b0100000;
						reset = 1'b1;
					end
					
					else if (row[4] && Rect_X_Pos >= alien_x + 10'd60 && Rect_X_Pos < alien_x + 10'd81)
					begin
						is_proj = 1'b0;
						hit = 7'b0010000;
						reset = 1'b1;
					end
					
					else if (row[3] && Rect_X_Pos >= alien_x + 10'd90 && Rect_X_Pos < alien_x + 10'd111)
					begin
						is_proj = 1'b0;
						hit = 7'b0001000;
						reset = 1'b1;
					end
					
					else if (row[2] && Rect_X_Pos >= alien_x + 10'd120 && Rect_X_Pos < alien_x + 10'd141)
					begin
						is_proj = 1'b0;
						hit = 7'b0000100;
						reset = 1'b1;
					end
					
					else if (row[1] && Rect_X_Pos >= alien_x + 10'd150 && Rect_X_Pos < alien_x + 10'd171)
					begin
						is_proj = 1'b0;
						hit = 7'b0000010;
						reset = 1'b1;
					end
					else if (row[0] && Rect_X_Pos >= alien_x + 10'd180 && Rect_X_Pos < alien_x + 10'd201)
					begin
						is_proj = 1'b0;
						hit = 7'b0000001;
						reset = 1'b1;
					end
			
			end
			else if(is_proj && Rect_Y_Pos <= alienb_y + 10'd16 && Rect_Y_Pos > alienb_y)
			begin
				hitc = 7'b0; hit = 7'b0;
				if (rowb[6] && Rect_X_Pos >= alienb_x && Rect_X_Pos < alienb_x + 10'd21)
					begin
						is_proj = 1'b0;
						hitb = 7'b1000000;
						reset = 1'b1;
					end
					
					else if (rowb[5] && Rect_X_Pos >= alienb_x + 10'd30 && Rect_X_Pos < alienb_x + 10'd51)
					begin
						is_proj = 1'b0;
						hitb = 7'b0100000;
						reset = 1'b1;
					end
					
					else if (rowb[4] && Rect_X_Pos >= alienb_x + 10'd60 && Rect_X_Pos < alienb_x + 10'd81)
					begin
						is_proj = 1'b0;
						hitb = 7'b0010000;
						reset = 1'b1;
					end
					
					else if (rowb[3] && Rect_X_Pos >= alienb_x + 10'd90 && Rect_X_Pos < alienb_x + 10'd111)
					begin
						is_proj = 1'b0;
						hitb = 7'b0001000;
						reset = 1'b1;
					end
					
					else if (rowb[2] && Rect_X_Pos >= alienb_x + 10'd120 && Rect_X_Pos < alienb_x + 10'd141)
					begin
						is_proj = 1'b0;
						hitb = 7'b0000100;
						reset = 1'b1;
					end
					
					else if (rowb[1] && Rect_X_Pos >= alienb_x + 10'd150 && Rect_X_Pos < alienb_x + 10'd171)
					begin
						is_proj = 1'b0;
						hitb = 7'b0000010;
						reset = 1'b1;
					end
					else if (rowb[0] && Rect_X_Pos >= alienb_x + 10'd180 && Rect_X_Pos < alienb_x + 10'd201)
					begin
						is_proj = 1'b0;
						hitb = 7'b0000001;
						reset = 1'b1;
					end
			end
			else if(is_proj && Rect_Y_Pos <= alienc_y + 10'd16 && Rect_Y_Pos > alienc_y)
			begin
				hit = 7'b0; hitb = 7'b0;
				if (rowc[6] && Rect_X_Pos >= alienc_x && Rect_X_Pos < alienc_x + 10'd21)
				begin
					is_proj = 1'b0;
					hitc = 7'b1000000;
					reset = 1'b1;
				end
				
				else if (rowc[5] && Rect_X_Pos >= alienc_x + 10'd30 && Rect_X_Pos < alienc_x + 10'd51)
				begin
					is_proj = 1'b0;
					hitc = 7'b0100000;
					reset = 1'b1;
				end
				
				else if (rowc[4] && Rect_X_Pos >= alienc_x + 10'd60 && Rect_X_Pos < alienc_x + 10'd81)
				begin
					is_proj = 1'b0;
					hitc = 7'b0010000;
					reset = 1'b1;
				end
				
				else if (rowc[3] && Rect_X_Pos >= alienc_x + 10'd90 && Rect_X_Pos < alienc_x + 10'd111)
				begin
					is_proj = 1'b0;
					hitc = 7'b0001000;
					reset = 1'b1;
				end
				
				else if (rowc[2] && Rect_X_Pos >= alienc_x + 10'd120 && Rect_X_Pos < alienc_x + 10'd141)
				begin
					is_proj = 1'b0;
					hitc = 7'b0000100;
					reset = 1'b1;
				end
				
				else if (rowc[1] && Rect_X_Pos >= alienc_x + 10'd150 && Rect_X_Pos < alienc_x + 10'd171)
				begin
					is_proj = 1'b0;
					hitc = 7'b0000010;
					reset = 1'b1;
				end
				else if (rowc[0] && Rect_X_Pos >= alienc_x + 10'd180 && Rect_X_Pos < alienc_x + 10'd201)
				begin
					is_proj = 1'b0;
					hitc = 7'b0000001;
					reset = 1'b1;
				end
			end
		end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else
			begin
			is_proj = 1'b0;
			hitc = 7'b0;
			hit = 7'b0;
			hitb = 7'b0;
			end
	 end

	 
	 assign proj_x = Rect_X_Pos;
	 assign proj_y = Rect_Y_Pos;
    
endmodule
