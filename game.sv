/*
Space-Invaders/Galaga-Inspired Fixed Shooter Game
ECE 385 - ABM
annam4, mgau2

This is the top-level for our project

*/
module game( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [7:0] keycode;
	 logic [9:0] DrawX, DrawY;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
//     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
// local vairables and connections 
	 logic  is_me, is_proj, is_alien, alien_0, alien_1, alien_2, alien_3, alien_4, alien_5, alien_6, is_alienb, alienb_0, alienb_1, alienb_2, alienb_3, alienb_4, alienb_5, alienb_6, alienb_7, is_alienc, alienc_0, alienc_1, alienc_2, alienc_3, alienc_4, alienc_5, alienc_6, alienc_7;
	 logic all_stat1, all_stat2, all_stat3, stat_0, stat_1, stat_2, stat_3, stat_4, stat_5, stat_6,
								  statb_0, statb_1, statb_2, statb_3, statb_4, statb_5, statb_6,
								  statc_0, statc_1, statc_2, statc_3, statc_4, statc_5, statc_6;
	 logic [2:0] curr_state;
	 logic [9:0] ship_x, proj_x, proj_y, alien_x, alien_y, alienb_x, alienb_y, alienc_x, alienc_y;
	 logic [10:0] score_address, start_addr, over_addr, win_addr, pause_addr;
	 logic [8:0] alien_ramaddr, alien_addr, alien_addrb, alien_addrc, ship_addrW, ship_addrR, ship_addrB;
	 logic [3:0] pindex, alien_index, ship_index;
	 logic [23:0] colors_A;
	 logic [6:0] rowc, hitc, rowb, hitb, row, hit;
	 logic [9:0] fire_count;
	 logic bottom, bottomb, bottomc, lose, win;
	 logic point, pointb, pointc;
	 
// for VGA:
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
	 
    VGA_controller vga_controller_instance(.Clk, .Reset(Reset_h), .VGA_HS, .VGA_VS, .VGA_CLK, .VGA_BLANK_N, .VGA_SYNC_N, .DrawX, .DrawY);
    
// Gameplay state-machine:
	 game_state state_machine(.Clk(VGA_VS), .Reset(Reset_h), .keycode, .curr_state, .lose, .win);/* .win, .lose);*/
							
// Ship, projectile, and alien mechanic modules:
    player ship(.Clk, .Reset(Reset_h), .curr_state, .frame_clk(VGA_VS), .DrawX, .DrawY, .ship_x, .ship_addrW, .ship_addrR, .ship_addrB, .is_me, .keycode);
	 
	 alien_m alien0(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .is_alien, .alien_addr, .keycode, .curr_state,
						 .alien_0, .alien_1, .alien_2, .alien_3, .alien_4, .alien_5, .alien_6, .alien_x, .alien_y, .bottom);
	 alien_b alienb(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .is_alienb, .alien_addr(alien_addrb), .keycode, .curr_state,
						 .alienb_0, .alienb_1, .alienb_2, .alienb_3, .alienb_4, .alienb_5, .alienb_6, .alienb_x, .alienb_y, .bottom(bottomb), .alien_y, .alienc_y);
    alien_c alienc(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .is_alienc, .alien_addr(alien_addrc), .keycode, .curr_state,
						 .alienc_0, .alienc_1, .alienc_2, .alienc_3, .alienc_4, .alienc_5, .alienc_6, .alienc_x, .alienc_y, .bottom(bottomc));
						 
	 projectile my_proj(.Clk, .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX, .DrawY, .ship_x, .keycode, 
							  .proj_x, .proj_y, .is_proj, .alien_x, .alien_y, .alienb_x, .alienb_y, .alienc_x, .alienc_y, 
							  .hit, .row, .hitb, .rowb, .hitc, .rowc, .curr_state, .fire_count);
	
// alien status arrays:
	 stat_array status_m(.Clk, .Reset(Reset_h), .hit(hit), .curr_state, .row(row), .point, .proj_y);
	 stat_array status_b(.Clk, .Reset(Reset_h), .hit(hitb), .curr_state, .row(rowb), .point(pointb), .proj_y);
	 stat_array status_c(.Clk, .Reset(Reset_h), .hit(hitc), .curr_state, .row(rowc), .point(pointc), .proj_y);

					
// RAM for sprites
	 alienRAM alien_map(.read_address(alien_ramaddr), .Clk, .data_Out(alien_index));
////	 shipRAM ship_map(.read_address(ship_addr), .Clk, .data_Out(ship_index));
	 palette color_pal(.read_address(pindex), .Clk, .data_Out(colors_A));
	 
// Special state screens	 
	 score score_text(.Clk, .Reset(Reset_h), .curr_state, .row, .rowb, .rowc, .DrawX, .DrawY, .score_address, .fire_count);
//	 score score_text(.Clk, .Reset(Reset_h), .curr_state, .point, .pointb, .pointc, .DrawX, .DrawY, .score_address, .fire_count);
	 
	 game_start start(.DrawX, .DrawY, .start_addr);
	 
	 game_over over(.DrawX, .DrawY, .over_addr);
	 
	 game_win u_win(.DrawX, .DrawY, .win_addr);
	 
	 	 
	 game_pause pause(.DrawX, .DrawY, .pause_addr);
	 
// Color mapping onto screen
	 logic [7:0] winR, winG, winB;
	 color_mapper color_instance(.is_me, .is_alien, .curr_state, .colors_A, .ship_x, .DrawX, .DrawY, .score_address, .start_addr, .over_addr, .win_addr, 
										  .pause_addr, .rowc, .rowb, .row, .winR, .winB, .winG,
										  .alien_addr, .ship_addrW, .ship_addrR, .ship_addrB, .VGA_R, .VGA_G, .VGA_B, .is_proj, .is_alienc, .is_alienb, 
										  .alien_0, .alien_1, .alien_2, .alien_3, .alien_4, .alien_5, .alien_6,
										  .alienb_0, .alienb_1, .alienb_2, .alienb_3, .alienb_4, .alienb_5, .alienb_6,
										  .alienc_0, .alienc_1, .alienc_2, .alienc_3, .alienc_4, .alienc_5, .alienc_6);
	 
	 colorful_win(.Clk(VGA_VS), .Reset(Reset_h), .curr_state, .winR, .winB, .winG);
	 	 
// Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);

// determine if the player has lost the game
always_comb
begin
	 lose = 1'b0;
	 if(rowc && bottomc || rowb && bottomb || row && bottom)
			lose = 1'b1;
end
	 
// determine if all aliens have been defeated
always_comb
begin
	 win = 1'b0;
	 if(rowc == 7'd0 && rowb == 7'd0 && row == 7'd0)
			win = 1'b1;
end
	 
// For choosing the appropriate index when using RAM palette
// (May not be necessary after switching to sprite_rom for ship)
always_comb
begin
	if(is_alien || is_alienb || is_alienc)
		pindex = alien_index;
	else
		pindex = ship_index;
end
always_comb
begin
	if(is_alienb)
		alien_ramaddr = alien_addrb;
	else if(is_alienc)
		alien_ramaddr = alien_addrc;
	else
			alien_ramaddr = alien_addr;
end

endmodule
