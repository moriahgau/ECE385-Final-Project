/*
	This module defines the movement allowed by the player. The player is confined to the black game area. It
	can only move horizontally and never vertically. When 'A' is held, the ship will move left. When 'D' is held,
	the ship will move right. If an edge is encountered the ship will bounce back.
*/
module  player ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					input [7:0]	  keycode,				 // keycode from the keyboard
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input logic [2:0] curr_state,
					
               output logic  is_me,             // Whether current pixel belongs to Rect or background		
					output logic [8:0] ship_addrW, ship_addrR, ship_addrB,
					output logic [9:0] ship_x, ship_y
              );
    
    parameter [9:0] Rect_X_Min = 10'd169;       // Leftmost point on the X axis
    parameter [9:0] Rect_X_Max = 10'd479;     // Rightmost point on the X axis
    parameter [9:0] Rect_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Rect_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Rect_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Rect_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Rect_Size = 10'd24;        // Rect size (X)
	 parameter [9:0] Rect_Y_Size = 10'd28;		 // Rect size (Y)
    
    logic [9:0] Rect_X_Pos, Rect_X_Motion, Rect_Y_Pos, Rect_Y_Motion;
	 logic [9:0] Rect_X_Pos_in, Rect_X_Motion_in, Rect_Y_Pos_in, Rect_Y_Motion_in;
	 

	 logic [7:0] A = 8'h04;
	 logic [7:0] D = 8'h07;
	 
	 logic[10:0] shape_x = 315;
	 logic[10:0] shape_y = 420;
	 logic[10:0] shape_size_x = 24;
	 logic[10:0] shape_size_y = 28;

	 
//	 assign ship_addr = (DrawY - Rect_Y_Pos)*shape_size_x + (DrawX - Rect_X_Pos);
// determine if the current pixel is part of the ship or not	 
	 always_comb
	 begin
		if(DrawX>= Rect_X_Pos && DrawX < Rect_X_Pos + shape_size_x && DrawY >= Rect_Y_Pos && DrawY < Rect_Y_Pos + shape_size_y)
			begin
			is_me = 1'b1;
			ship_addrW = (DrawY - Rect_Y_Pos);
			ship_addrR = (DrawY - Rect_Y_Pos) + 28*'h01;
			ship_addrB = (DrawY - Rect_Y_Pos) + 28*'h02;
			end
		else
			begin
			is_me = 1'b0;
			ship_addrW = 8'd0;
			ship_addrR = 8'd0;
			ship_addrB = 8'd0;
			end
	 end
	 
/////////////////////////////////////////////////////////////////////////////////////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset || curr_state == 3'd0 || curr_state == 3'd6)
        begin
            Rect_X_Pos <= shape_x;
            Rect_Y_Pos <= shape_y;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
        end
		  else if(curr_state == 3'd2 || curr_state == 3'd1)
		  begin
            Rect_X_Pos <= Rect_X_Pos;
            Rect_Y_Pos <= Rect_Y_Pos;
            Rect_X_Motion <= 10'd0;
            Rect_Y_Motion <= 10'd0;
		  end
        else
        begin
            Rect_X_Pos <= Rect_X_Pos_in;
            Rect_Y_Pos <= Rect_Y_Pos_in;
            Rect_X_Motion <= Rect_X_Motion_in;
            Rect_Y_Motion <= Rect_Y_Motion_in;
        end
    end
 ///////////////////////////////////////////////////////////////////////////////////////
    always_comb
    begin
        // By default, keep motion and position unchanged
        Rect_X_Pos_in = Rect_X_Pos;
        Rect_Y_Pos_in = Rect_Y_Pos;
        Rect_X_Motion_in = Rect_X_Motion;
        Rect_Y_Motion_in = Rect_Y_Motion;
        
// Update position and motion of ship only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				if( Rect_X_Pos + Rect_Size >= Rect_X_Max )  // Rect is at the right edge, BOUNCE!
                Rect_X_Motion_in = 10'd0;  // 2's complement.  
            else if ( Rect_X_Pos <= Rect_X_Min )  // Rect is at the left edge, BOUNCE!
                Rect_X_Motion_in = 10'd0;
				
			
				// Keypress handling
				unique case (keycode)
			 
				A:
				begin
					Rect_X_Motion_in = (~(Rect_X_Step) + 1'b1);
					Rect_Y_Motion_in = 10'd0;
					

					if( Rect_X_Pos + Rect_Size >= Rect_X_Max - 1'b1)  // Rect is at the right edge, BOUNCE!
					begin
						 Rect_X_Motion_in = (~Rect_X_Step) + 10'd1;  // 2's complement.
					end
					else if ( Rect_X_Pos <= Rect_X_Min + 1'b1)  // Rect is at the left edge, BOUNCE!
					begin
						 Rect_X_Motion_in = Rect_X_Step;
					end
				end
					 
				D:
				begin
					Rect_X_Motion_in = (Rect_X_Step);
					Rect_Y_Motion_in = 10'd0;

					if( Rect_X_Pos + Rect_Size >= Rect_X_Max - 1'b1)  // Rect is at the right edge, BOUNCE!
					begin
						 Rect_X_Motion_in = (~Rect_X_Step) + 10'd1;  // 2's complement.  
					end
					else if ( Rect_X_Pos <= Rect_X_Min + 1'b1)  // Rect is at the left edge, BOUNCE!
					begin
						 Rect_X_Motion_in = Rect_X_Step;
					end
				end
							 
				default:
				begin
				
				  Rect_X_Motion_in = 10'd0;
				  Rect_Y_Motion_in = 10'd0;
		
				end
				
				endcase
				
        
            // Update the Rect's position with its motion
            Rect_X_Pos_in = Rect_X_Pos + Rect_X_Motion;
            Rect_Y_Pos_in = Rect_Y_Pos + Rect_Y_Motion;
        end
		 
		end
// assign the ship_x output
		assign ship_x = Rect_X_Pos;
		assign ship_y = Rect_Y_Pos;
           
endmodule
