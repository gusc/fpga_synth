`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LU
// Engineer: Gusts
// 
// Create Date:    13:41:59 05/16/2018 
// Design Name:    fpga_synth
// Module Name:    main 
// Project Name: 
// Target Devices: Spartan 3E Starter Kit + FX2-BB
// Tool versions: 
// Description: MIDI serial data parser module
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
//   https://www.midi.org/specifications/item/table-1-summary-of-midi-message 
//
//////////////////////////////////////////////////////////////////////////////////
module MIDIParse(
		input [7:0] midi_byte,
		input midi_ready,
		output [23:0] out_freq,
		output [6:0] out_vel,
		output out_play
    );

	reg[7:0] byte_input = 0; // Local copy of MIDI byte
	reg[3:0] read_state = 0; // command, note, velocity, reserved steps to skip all other MIDI commands
	reg[0:0] note_off = 0;	 // This is a note-off message
	// Output is 24 bit integer, because highest frequency is 4186Hz * 1000
	reg[23:0] frequency = 0;
	reg[6:0] velocity = 0;
	reg[0:0] playing = 0;
	
	always @(posedge midi_ready) begin
		byte_input = midi_byte;
		case (read_state)
			0: // Read MIDI command
			begin
				if (byte_input & 'hF0 == 8'b10010000) begin
					// Note-on message (all channel)
					note_off <= 0;
					read_state <= read_state + 1;
				end
				else if (byte_input & 'hF0 == 8'b10000000) begin
					// Note-off message (all channels)
					note_off <= 1;
					read_state <= read_state + 1;
				end
				else if (byte_input & 'hF0 == 8'b11000000
						|| byte_input & 'hF0 == 8'b11010000) begin
					// Program change and Channel pressure messages have single byte data
					read_state <= 4;
				end
				else begin
					// Rest of standard commands have 2 bytes following
					read_state <= 3;
				end
			end
			1: // Read Note number
			begin
				// Note frequency lookup table
				case (byte_input)
					0: frequency<=8175;
					1: frequency<=8661;
					2: frequency<=9177;
					3: frequency<=9722;
					4: frequency<=10300;
					5: frequency<=10913;
					6: frequency<=11562;
					7: frequency<=12249;
					8: frequency<=12978;
					9: frequency<=13750;
					10: frequency<=14567;
					11: frequency<=15433;
					12: frequency<=16351;
					13: frequency<=17323;
					14: frequency<=18354;
					15: frequency<=19445;
					16: frequency<=20601;
					17: frequency<=21826;
					18: frequency<=23124;
					19: frequency<=24499;
					20: frequency<=25956;
					21: frequency<=27500;
					22: frequency<=29135;
					23: frequency<=30867;
					24: frequency<=32703;
					25: frequency<=34647;
					26: frequency<=36708;
					27: frequency<=38890;
					28: frequency<=41203;
					29: frequency<=43653;
					30: frequency<=46249;
					31: frequency<=48999;
					32: frequency<=51913;
					33: frequency<=55000;
					34: frequency<=58270;
					35: frequency<=61735;
					36: frequency<=65406;
					37: frequency<=69295;
					38: frequency<=73416;
					39: frequency<=77781;
					40: frequency<=82406;
					41: frequency<=87307;
					42: frequency<=92498;
					43: frequency<=97998;
					44: frequency<=103826;
					45: frequency<=110000;
					46: frequency<=116540;
					47: frequency<=123470;
					48: frequency<=130812;
					49: frequency<=138591;
					50: frequency<=146832;
					51: frequency<=155563;
					52: frequency<=164813;
					53: frequency<=174614;
					54: frequency<=184997;
					55: frequency<=195997;
					56: frequency<=207652;
					57: frequency<=220000;
					58: frequency<=233081;
					59: frequency<=246941;
					60: frequency<=261625;
					61: frequency<=277182;
					62: frequency<=293664;
					63: frequency<=311126;
					64: frequency<=329627;
					65: frequency<=349228;
					66: frequency<=369994;
					67: frequency<=391995;
					68: frequency<=415304;
					69: frequency<=440000;
					70: frequency<=466163;
					71: frequency<=493883;
					72: frequency<=523251;
					73: frequency<=554365;
					74: frequency<=587329;
					75: frequency<=622253;
					76: frequency<=659255;
					77: frequency<=698456;
					78: frequency<=739988;
					79: frequency<=783990;
					80: frequency<=830609;
					81: frequency<=880000;
					82: frequency<=932327;
					83: frequency<=987766;
					84: frequency<=1046502;
					85: frequency<=1108730;
					86: frequency<=1174659;
					87: frequency<=1244507;
					88: frequency<=1318510;
					89: frequency<=1396912;
					90: frequency<=1479977;
					91: frequency<=1567981;
					92: frequency<=1661218;
					93: frequency<=1760000;
					94: frequency<=1864655;
					95: frequency<=1975533;
					96: frequency<=2093004;
					97: frequency<=2217461;
					98: frequency<=2349318;
					99: frequency<=2489015;
					100: frequency<=2637020;
					101: frequency<=2793825;
					102: frequency<=2959955;
					103: frequency<=3135963;
					104: frequency<=3322437;
					105: frequency<=3520000;
					106: frequency<=3729310;
					107: frequency<=3951066;
					108: frequency<=4186009;
					109: frequency<=4434922;
					110: frequency<=4698636;
					111: frequency<=4978031;
					112: frequency<=5274040;
					113: frequency<=5587651;
					114: frequency<=5919910;
					115: frequency<=6271926;
					116: frequency<=6644875;
					117: frequency<=7040000;
					118: frequency<=7458620;
					119: frequency<=7902132;
					120: frequency<=8372018;
					121: frequency<=8869844;
					122: frequency<=9397272;
					123: frequency<=9956063;
					124: frequency<=10548081;
					125: frequency<=11175303;
					126: frequency<=11839821;
					127: frequency<=12543853;
				endcase
				read_state <= read_state + 1; // Move to velocity byte
			end
			2: // Read velocity
			begin
				if (byte_input == 0 || note_off == 1) begin
					// Velocity is 0 or note-off received
					velocity <= 0;
					playing <= 0;
				end
				else begin
					velocity <= byte_input[6:0];
					playing <= 1;
				end
				read_state <= 0; // Wait for next command
			end
			3: read_state <= read_state + 1; // Skip 2 bytes
			4: read_state <= read_state + 1; // Skip 1 byte
		endcase
	end
	
	assign out_play = playing;
	assign out_vel = velocity;
	assign out_freq = frequency;

endmodule
