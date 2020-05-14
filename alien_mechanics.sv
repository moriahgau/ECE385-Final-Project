/* 
	This file contains the modules to specify the movement of our 3 alien types. 
	1. alien_m
		These green aliens start at the top of the screen. They move left and right. When an edge is encountered,
		they descend. At specified y-coordinates, this alien increases speed.
	2. alien_b
		These turquiose aliens start below the alien_m row. The move left and right and descned when an edge is 
		encountered similarly to alien_m. The difference is that these aliens also bounce between the row above and
		below them, creating a somewhat random movement effect.
	3. alien_c
		These pink aliens behave identically to alien_m. The difference is that they begin at a lower y-coordinate.

*/                                                           
                                                        
/////Alien Type 1////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module  alien_m ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]	  keycode,				 // keycode from the keyboard
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [2:0] curr_state,
					
               output logic  is_alien, bottom,             // Whether current pixel belongs to wave or background
									// signals for individual aliens within the wave
									  alien_0, alien_1, alien_2, alien_3, alien_4, alien_5, alien_6,
					output logic [9:0] alien_x, alien_y,
					output logic [8:0] alien_addr
              );
 // parameters for wave  
    parameter [9:0] Rect_X_Min = 10'd170;       // Leftmost point on the X axis
    parameter [9:0] Rect_X_Max = 10'd478;     // Rightmost point on the ;X axis
    parameter [9:0] Rect_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Rect_Y_Max = 10'd479;     // Bottommost point on the Y axis
    logic [9:0] Rect_X_Step = 10'd01;      // Step size on the X axis
 
    parameter [9:0] Rect_X_Size = 10'd201;        // Wave size
	 parameter [9:0] Rect_Y_size = 10'd16;
    
    logic [9:0] Rect_X_Pos, Rect_X_Motion, Rect_Y_Pos, Rect_Y_Motion;
	 logic [9:0] Rect_X_Pos_in, Rect_X_Motion_in, Rect_Y_Pos_in, Rect_Y_Motion_in;

// parameters for individual aliens
	 logic[10:0] shape_size_x = 21;
	 logic[10:0] shape_size_y = 16;
	 logic[10:0] shape_space = 9;
// determine if the alien should be stopped or moving
	 logic move;
	 
	 assign alien_x = Rect_X_Pos;
	 assign alien_y = Rect_Y_Pos;
	 
// slow down the horizontal motion of the alien
// Control the animation offset for the aliens		
	 logic up;
	 dynamic_alien anim(.Clk(frame_clk), .Reset, .speed(Rect_X_Step), .up);
//	 assign alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Assign pixels to the alien row	(finish calculations and logic)
	 always_comb
	 begin
		alien_addr = 8'd0;
		alien_0 = 1'b0; alien_1 = 1'b0; alien_2 = 1'b0; alien_3 = 1'b0; alien_4 = 1'b0; alien_5 = 1'b0; alien_6 = 1'b0;
		if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + Rect_X_Size && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
			begin
				is_alien = 1'b1;
	// alien 0
				if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + shape_size_x && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_0 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
					
					if(up && DrawX <= Rect_X_Pos + 10'd2 || DrawX > Rect_X_Pos + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 1
				else if(DrawX >= Rect_X_Pos + shape_space + shape_size_x && DrawX < Rect_X_Pos + 2*shape_size_x + shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_1 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + shape_space + shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + shape_space + shape_size_x + 10'd2 || DrawX > Rect_X_Pos + shape_space + shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 2
				else if(DrawX >= Rect_X_Pos + 2*shape_space + 2*shape_size_x && DrawX < Rect_X_Pos + 3*shape_size_x + 2*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_2 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 2*shape_space + 2*shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 3
				else if(DrawX >= Rect_X_Pos + 3*shape_space + 3*shape_size_x && DrawX < Rect_X_Pos + 4*shape_size_x + 3*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_3 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 3*shape_space + 3*shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				
				end
	// alien 4
				else if(DrawX >= Rect_X_Pos + 4*shape_space + 4*shape_size_x && DrawX < Rect_X_Pos + 5*shape_size_x + 4*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_4 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 4*shape_space + 4*shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;			

				
				end
	// alien 5
				else if(DrawX >= Rect_X_Pos + 5*shape_space + 5*shape_size_x && DrawX < Rect_X_Pos + 6*shape_size_x + 5*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_5 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 5*shape_space + 5*shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
   // alien 6
				else if(DrawX >= Rect_X_Pos + 6*shape_space + 6*shape_size_x && DrawX < Rect_X_Pos + 7*shape_size_x + 6*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alien_6 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 6*shape_space + 6*shape_size_x));
					
					if(up && DrawX <= Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
				else
					is_alien = 1'b0;
			end
				
// not the alien row
		else
			begin
			is_alien = 1'b0;
			alien_1 = 1'b0; alien_2= 1'b0; alien_3 = 1'b0; alien_4= 1'b0;alien_5 = 1'b0; alien_6= 1'b0;
			end
	 end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb
begin
	Rect_X_Step = 10'd1;
	if(Rect_Y_Pos > 65)
		Rect_X_Step = 10'd2;
	if(Rect_Y_Pos > 240)
		Rect_X_Step = 10'd3;
end
///////////// FF BLOCK FOR MOVING WAVE //////////////////////////////////////////////////////////////////////////////////////////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 alien_horizontal control(.Clk(frame_clk_rising_edge), .Reset, .move);
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || curr_state == 3'd0 || curr_state == 3'd6)
        begin
            Rect_X_Pos <= 10'd170;
            Rect_Y_Pos <= 0;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= 10'd0;
        end
		  else if(curr_state == 3'd1 || curr_state == 3'd4)
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
		  end
		  else if(curr_state == 3'd2) // Pause
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
		  end
        else
        begin
            Rect_X_Pos <= Rect_X_Pos_in;
            Rect_Y_Pos <= Rect_Y_Pos_in;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
        end
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////// Specify the movement and behavior of alien row. /////////////////////////////////////////////////////////////////////////
    always_comb
    begin
        // By default, keep motion and position unchanged
        Rect_X_Pos_in = Rect_X_Pos;
        Rect_Y_Pos_in = Rect_Y_Pos;
        Rect_X_Motion_in = Rect_X_Motion;
        Rect_Y_Motion_in = Rect_Y_Motion;
		  bottom = 1'b0;
		  
		  if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )
		  begin
				bottom = 1'b1;
		  end
        
        // Update position and motion only at rising edge of frame clock and if the alien should be moving
        if (frame_clk_rising_edge && move == 1'b1)
        begin
		
            if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )  // Rect is at the bottom edge, BOUNCE!
                begin
					 Rect_X_Motion_in = 10'd0;
					 Rect_Y_Motion_in = 10'd0;  // GAME OVER
					 bottom = 1'b1;
					 end

				if( Rect_X_Pos + Rect_X_Size >= Rect_X_Max )  // Rect is at the right edge, BOUNCE!
				begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = (~(Rect_X_Step) + 1'b1);  // 2's complement.  
				end
            else if ( Rect_X_Pos <= Rect_X_Min )  // Rect is at the left edge, BOUNCE!
            begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = Rect_X_Step;
				end
					
        
            // Update the Rect's position with its motion
            Rect_X_Pos_in = Rect_X_Pos + Rect_X_Motion;
        end
	end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////Alien Type 2////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module  alien_b ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]	  keycode,				 // keycode from the keyboard
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [2:0] curr_state,
					input logic [9:0] alien_y, alienc_y, // Y coordinates of the row above and below
					
               output logic  is_alienb, bottom,            // Whether current pixel belongs to wave or background
									// signals for individual aliens within the wave
									  alienb_0, alienb_1, alienb_2, alienb_3, alienb_4, alienb_5, alienb_6,
					output logic [9:0] alienb_x, alienb_y,
					output logic [8:0] alien_addr
              );
 // parameters for wave  
    parameter [9:0] Rect_X_Min = 10'd170;       // Leftmost point on the X axis
    parameter [9:0] Rect_X_Max = 10'd478;     // Rightmost point on the ;X axis
    parameter [9:0] Rect_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Rect_Y_Max = 10'd479;     // Bottommost point on the Y axis
	 parameter [9:0] Rect_Y_Step = 10'd1;
    logic [9:0] Rect_X_Step = 10'd01;      // Step size on the X axis
 
    parameter [9:0] Rect_X_Size = 10'd201;        // Wave size
	 parameter [9:0] Rect_Y_size = 10'd16;
    
    logic [9:0] Rect_X_Pos, Rect_X_Motion, Rect_Y_Pos, Rect_Y_Motion;
	 logic [9:0] Rect_X_Pos_in, Rect_X_Motion_in, Rect_Y_Pos_in, Rect_Y_Motion_in;

// parameters for individual aliens
	 logic[10:0] shape_size_x = 21;
	 logic[10:0] shape_size_y = 16;
	 logic[10:0] shape_space = 9;
// determine if the alien should be stopped or moving
	 logic move;
	 
	 assign alienb_x = Rect_X_Pos;
	 assign alienb_y = Rect_Y_Pos;
	 
// slow down the horizontal motion of the alien
		
  
// Control the animation offset for the aliens		
	 logic up;
	 dynamic_alien anim(.Clk(frame_clk), .Reset, .speed(Rect_X_Step), .up);	 
//	 assign alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Assign pixels to the alien row	(finish calculations and logic)
	 always_comb
	 begin
		alien_addr = 8'd0;
		alienb_0 = 1'b0; alienb_1 = 1'b0; alienb_2 = 1'b0; alienb_3 = 1'b0; alienb_4 = 1'b0; alienb_5 = 1'b0; alienb_6 = 1'b0;
		if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + Rect_X_Size && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
			begin
				is_alienb = 1'b1;
	// alien 0
				if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + shape_size_x && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_0 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
					
										
					if(up && DrawX <= Rect_X_Pos + 10'd2 || DrawX > Rect_X_Pos + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 1
				else if(DrawX >= Rect_X_Pos + shape_space + shape_size_x && DrawX < Rect_X_Pos + 2*shape_size_x + shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_1 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + shape_space + shape_size_x));

					if(up && DrawX <= Rect_X_Pos + shape_space + shape_size_x + 10'd2 || DrawX > Rect_X_Pos + shape_space + shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 2
				else if(DrawX >= Rect_X_Pos + 2*shape_space + 2*shape_size_x && DrawX < Rect_X_Pos + 3*shape_size_x + 2*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_2 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 2*shape_space + 2*shape_size_x));
													
					if(up && DrawX <= Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
					
				end
	// alien 3
				else if(DrawX >= Rect_X_Pos + 3*shape_space + 3*shape_size_x && DrawX < Rect_X_Pos + 4*shape_size_x + 3*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_3 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 3*shape_space + 3*shape_size_x));
										
					if(up && DrawX <= Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 4
				else if(DrawX >= Rect_X_Pos + 4*shape_space + 4*shape_size_x && DrawX < Rect_X_Pos + 5*shape_size_x + 4*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_4 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 4*shape_space + 4*shape_size_x));
										
					if(up && DrawX <= Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 5
				else if(DrawX >= Rect_X_Pos + 5*shape_space + 5*shape_size_x && DrawX < Rect_X_Pos + 6*shape_size_x + 5*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_5 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 5*shape_space + 5*shape_size_x));
										
					if(up && DrawX <= Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
   // alien 6
				else if(DrawX >= Rect_X_Pos + 6*shape_space + 6*shape_size_x && DrawX < Rect_X_Pos + 7*shape_size_x + 6*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienb_6 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 6*shape_space + 6*shape_size_x));
										
					if(up && DrawX <= Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
				else
					is_alienb = 1'b0;
			end
				
// not the alien row
		else
			begin
			is_alienb = 1'b0;
			alienb_1 = 1'b0; alienb_2= 1'b0; alienb_3 = 1'b0; alienb_4= 1'b0;alienb_5 = 1'b0; alienb_6= 1'b0;
			end
	 end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb
begin
	Rect_X_Step = 10'd1;
	if(Rect_Y_Pos > 65)
		Rect_X_Step = 10'd2;
	if(Rect_Y_Pos > 240)
		Rect_X_Step = 10'd3;
end
///////////// FF BLOCK FOR MOVING WAVE //////////////////////////////////////////////////////////////////////////////////////////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 alien_horizontal control(.Clk(frame_clk_rising_edge), .Reset, .move);
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || curr_state == 3'd0 || curr_state == 3'd6)
        begin
            Rect_X_Pos <= 10'd170;
            Rect_Y_Pos <= 10'd30;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Step;
        end
		  else if(curr_state == 3'd1 || curr_state == 3'd4)
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
		  end
		  else if(curr_state == 3'd2)	// PAUSE
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
		  end
        else
        begin
            Rect_X_Pos <= Rect_X_Pos_in;
            Rect_Y_Pos <= Rect_Y_Pos_in;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
        end
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////// Specify the movement and behavior of alien row. /////////////////////////////////////////////////////////////////////////
    always_comb
    begin
        // By default, keep motion and position unchanged
        Rect_X_Pos_in = Rect_X_Pos;
        Rect_Y_Pos_in = Rect_Y_Pos;
        Rect_X_Motion_in = Rect_X_Motion;
        Rect_Y_Motion_in = Rect_Y_Motion;
		  bottom = 1'b0;
        
		  if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )
		  begin
				bottom = 1'b1;
		  end
		  
        // Update position and motion only at rising edge of frame clock and if the alien should be moving
        if (frame_clk_rising_edge && move == 1'b1)
        begin

				if( Rect_X_Pos + Rect_X_Size >= Rect_X_Max )  // Rect is at the right edge, BOUNCE!
				begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = (~(Rect_X_Step) + 1'b1);  // 2's complement.  
				end
            else if ( Rect_X_Pos <= Rect_X_Min )  // Rect is at the left edge, BOUNCE!
            begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = Rect_X_Step;
				end
				
				else
				begin
					if(Rect_Y_Pos <= alien_y + 10'd18)
						Rect_Y_Motion_in = Rect_Y_Step;
					else if(Rect_Y_Pos +10'd18 >= alienc_y)
						Rect_Y_Motion_in = ~Rect_Y_Step + 1'b1;
						
					Rect_Y_Pos_in = Rect_Y_Pos + Rect_Y_Motion;
				end
					
			   if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )  // Rect is at the bottom edge, BOUNCE!
            begin
					 Rect_X_Motion_in = 10'd0;
					 Rect_Y_Motion_in = 10'd0;  // GAME OVER
					 Rect_Y_Pos_in = Rect_Y_Pos + Rect_Y_Motion;
					 bottom= 1'b1;
				end
            // Update the Rect's position with its motion
            Rect_X_Pos_in = Rect_X_Pos + Rect_X_Motion;
        end
	end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////Alien Type 3////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module  alien_c ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]	  keycode,				 // keycode from the keyboard
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [2:0] curr_state,
					
					output logic bottom,					 // high if the row has reached the bottom
               output logic  is_alienc,             // Whether current pixel belongs to wave or background
									// signals for individual aliens within the wave
									  alienc_0, alienc_1, alienc_2, alienc_3, alienc_4, alienc_5, alienc_6,
					output logic [9:0] alienc_x, alienc_y,
					output logic [8:0] alien_addr
              );
 // parameters for wave  
    parameter [9:0] Rect_X_Min = 10'd170;       // Leftmost point on the X axis
    parameter [9:0] Rect_X_Max = 10'd478;     // Rightmost point on the ;X axis
    parameter [9:0] Rect_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Rect_Y_Max = 10'd479;     // Bottommost point on the Y axis
    logic [9:0] Rect_X_Step = 10'd1;      // Step size on the X axis
 
    parameter [9:0] Rect_X_Size = 10'd201;        // Wave size
	 parameter [9:0] Rect_Y_size = 10'd16;
    
    logic [9:0] Rect_X_Pos, Rect_X_Motion, Rect_Y_Pos, Rect_Y_Motion;
	 logic [9:0] Rect_X_Pos_in, Rect_X_Motion_in, Rect_Y_Pos_in, Rect_Y_Motion_in;

// parameters for individual aliens
	 logic[10:0] shape_size_x = 21;
	 logic[10:0] shape_size_y = 16;
	 logic[10:0] shape_space = 9;
// determine if the alien should be stopped or moving
	 logic move;
	 
	 assign alienc_x = Rect_X_Pos;
	 assign alienc_y = Rect_Y_Pos;
	 
// slow down the horizontal motion of the alien
		
  
	 // Control the animation offset for the aliens		
	 logic up;
	 dynamic_alien anim(.Clk(frame_clk), .Reset, .speed(Rect_X_Step), .up);
//	 assign alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Assign pixels to the alien row	(finish calculations and logic)
	 always_comb
	 begin
		alien_addr = 8'd0;
		alienc_0 = 1'b0; alienc_1 = 1'b0; alienc_2 = 1'b0; alienc_3 = 1'b0; alienc_4 = 1'b0; alienc_5 = 1'b0; alienc_6 = 1'b0;
		if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + Rect_X_Size && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
			begin
				is_alienc = 1'b1;
	// alien 0
				if(DrawX >= Rect_X_Pos && DrawX < Rect_X_Pos + shape_size_x && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_0 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
					
					if(up && DrawX <= Rect_X_Pos + 10'd2 || DrawX > Rect_X_Pos + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 1
				else if(DrawX >= Rect_X_Pos + shape_space + shape_size_x && DrawX < Rect_X_Pos + 2*shape_size_x + shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_1 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + shape_space + shape_size_x));
										
					if(up && DrawX <= Rect_X_Pos + shape_space + shape_size_x + 10'd2 || DrawX > Rect_X_Pos + shape_space + shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 2
				else if(DrawX >= Rect_X_Pos + 2*shape_space + 2*shape_size_x && DrawX < Rect_X_Pos + 3*shape_size_x + 2*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_2 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 2*shape_space + 2*shape_size_x));
														
					if(up && DrawX <= Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 2*shape_space + 2*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 3
				else if(DrawX >= Rect_X_Pos + 3*shape_space + 3*shape_size_x && DrawX < Rect_X_Pos + 4*shape_size_x + 3*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_3 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 3*shape_space + 3*shape_size_x));
														
					if(up && DrawX <= Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 3*shape_space + 3*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 4
				else if(DrawX >= Rect_X_Pos + 4*shape_space + 4*shape_size_x && DrawX < Rect_X_Pos + 5*shape_size_x + 4*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_4 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 4*shape_space + 4*shape_size_x));
														
					if(up && DrawX <= Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 4*shape_space + 4*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
	// alien 5
				else if(DrawX >= Rect_X_Pos + 5*shape_space + 5*shape_size_x && DrawX < Rect_X_Pos + 6*shape_size_x + 5*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_5 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 5*shape_space + 5*shape_size_x));
														
					if(up && DrawX <= Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 5*shape_space + 5*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
   // alien 6
				else if(DrawX >= Rect_X_Pos + 6*shape_space + 6*shape_size_x && DrawX < Rect_X_Pos + 7*shape_size_x + 6*shape_space && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
				begin
					alienc_6 = 1'b1;
					alien_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - (Rect_X_Pos + 6*shape_space + 6*shape_size_x));
														
					if(up && DrawX <= Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd2 || DrawX > Rect_X_Pos + 6*shape_space + 6*shape_size_x + 10'd17 && up)
						alien_addr = alien_addr + 10'd336;
				end
				else
					is_alienc = 1'b0;
			end
				
// not the alien row
		else
			begin
			is_alienc = 1'b0;
			alienc_1 = 1'b0; alienc_2= 1'b0; alienc_3 = 1'b0; alienc_4= 1'b0;alienc_5 = 1'b0; alienc_6= 1'b0;
			end
	 end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always_comb
begin
	Rect_X_Step = 10'd1;
	if(Rect_Y_Pos > 65)
		Rect_X_Step = 10'd2;
	if(Rect_Y_Pos > 240)
		Rect_X_Step = 10'd3;
end

///////////// FF BLOCK FOR MOVING WAVE //////////////////////////////////////////////////////////////////////////////////////////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 alien_horizontal control(.Clk(frame_clk_rising_edge), .Reset, .move);
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || curr_state == 3'd0 || curr_state == 3'd6)
        begin
            Rect_X_Pos <= 10'd170;
            Rect_Y_Pos <= 10'd60;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= 10'd0;
        end
		  else if(curr_state == 3'd1 || curr_state == 3'd4) // GameOver or Win
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
		  end
		  else if(curr_state == 3'd2)
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
		  end
        else
        begin
            Rect_X_Pos <= Rect_X_Pos_in;
            Rect_Y_Pos <= Rect_Y_Pos_in;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
        end
    end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////// Specify the movement and behavior of alien row. /////////////////////////////////////////////////////////////////////////
    always_comb
    begin
        // By default, keep motion and position unchanged
        Rect_X_Pos_in = Rect_X_Pos;
        Rect_Y_Pos_in = Rect_Y_Pos;
        Rect_X_Motion_in = Rect_X_Motion;
        Rect_Y_Motion_in = Rect_Y_Motion;
		  bottom = 1'b0;
		  
        if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )
		  begin
				bottom = 1'b1;
		  end
        // Update position and motion only at rising edge of frame clock and if the alien should be moving
        if (frame_clk_rising_edge && move == 1'b1)
        begin
		
            if( Rect_Y_Pos + Rect_Y_size >= 10'd420 )  // Rect is at the bottom edge, BOUNCE!
                begin
					 Rect_X_Motion_in = 10'd0;
					 Rect_Y_Motion_in = 10'd0;  // GAME OVER
					 bottom = 1'b1;
					 end

				if( Rect_X_Pos + Rect_X_Size >= Rect_X_Max )  // Rect is at the right edge, BOUNCE!
				begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = (~(Rect_X_Step) + 1'b1);  // 2's complement.  
				end
            else if ( Rect_X_Pos <= Rect_X_Min )  // Rect is at the left edge, BOUNCE!
            begin
					 Rect_Y_Pos_in = Rect_Y_Pos + 10'd4;
					 Rect_X_Motion_in = Rect_X_Step;
				end
					
        
            // Update the Rect's position with its motion
            Rect_X_Pos_in = Rect_X_Pos + Rect_X_Motion;
        end
	end
endmodule
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
	This module slows down the horizontal movement of the aliens in order to make the game more playable. It does this by
	outputting a go variable that tells the alien modules that the x-coordinate values can be updated.The go variable is
	high in the Go state and low in the Stop states.
*/
module alien_horizontal(input logic Clk, Reset,

								output logic move
);
								
	enum logic [1:0]{Stop_1, Stop_2, Stop_3, Go} state, next_state;	

always_ff @ (posedge Clk)
begin
	if (Reset) 
	begin
		state <= Go;
	end
		
	else 
	begin
		state <= next_state;
	end
end

always_comb
begin
	unique case(state)
		Go:
		begin
			next_state = Stop_1;
			move = 1'b1;
		end
		
		Stop_1:
		begin
			move = 1'b0;
			next_state = Go;
		end
		
		Stop_2:
		begin
			move = 1'b0;
			next_state = Go;
		end

		
		Stop_3:
		begin
			move = 1'b0;
			next_state = Go;
		end
		
	endcase

end
endmodule

/* 
	The output determines if the alien arms should be up or down to give the aliens the illusion of movement.
	Based on the value of the counter, the up variable will take on a different value. It will be used to determine
	if the first alien sprite in the ram (arms down) or the second alien sprite (arms up) should be used.
*/

module dynamic_alien(input logic Clk, Reset,
								input logic [9:0] speed,
								output logic up
);
								
	enum logic {A, B} state, next_state;	
	logic  [4:0] counter;
	
	
always_ff @ (posedge Clk)
begin
	if (Reset) 
	begin
		state <= A;
		counter <= 5'd0;
	end
		
	else 
	begin
		state <= next_state;
		counter <= counter + 1'b1;
	end
end

always_comb
begin
	unique case(state)
		A:
		begin
			if(counter < 16)
			begin 
				next_state = A;
			end
			else
			begin
				next_state = B;
			end
			up = 1'b0;
		end
		
		B:
		begin
			if(counter >= 16)
			begin 
				next_state = B;
			end
			else
			begin
				next_state = A;
			end
			up = 1'b1;
			
		end

		
	endcase

end
endmodule
