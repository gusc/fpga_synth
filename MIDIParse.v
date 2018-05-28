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
		input [7:0] midiByte,
		input midiReady,
		output [6:0] outFrequencyIndex,
		output [6:0] outVelocity,
		output outPlaying
    );

	reg[3:0] readState = 0; // command, note, velocity, reserved steps to skip all other MIDI commands
	reg noteOff = 0;	 // This is a note-off message
	// Output is 24 bit integer, because highest frequency is 4186Hz * 1000
	reg[6:0] frequencyIndex = 0;
	reg[6:0] velocity = 0;
	reg playing = 0;
	
	always @(posedge midiReady) begin
		case (readState)
			0: // Read MIDI command
			begin
				$display("8'hF0 => %b", 8'hF0);
				$display("midi_byte & 8'hF0 => %b", midiByte & 8'hF0);
				if ((midiByte & 8'hF0) == 8'b10010000) begin
					// Note-on message (all channel)
					noteOff <= 0;
					readState <= readState + 1;
					$display("midi_byte & 8'hF0 == 8'b10010000: Note-on message (all channel)");
				end
				else if ((midiByte & 8'hF0) == 8'b10000000) begin
					// Note-off message (all channels)
					noteOff <= 1;
					readState <= readState + 1;
					$display("midi_byte & 8'hF0 == 8'b10000000: Note-off message (all channels)");
				end
				else if (((midiByte & 8'hF0) == 8'b11000000)
						|| ((midiByte & 8'hF0) == 8'b11010000)) begin
					// Program change and Channel pressure messages have 
					// single byte data.
					readState <= 4;
					$display("midi_byte & 8'hF0 == 8'b11000000 || midi_byte & 8'hF0 == 8'b11010000: Program change and Channel pressure messages have single byte data.");
				end
				else begin
					// Rest of standard commands have 2 bytes following
					// except for SysEx messages, be let's hope nobody sends
					// them to us.
					readState <= 3;
					$display("else: Rest of standard commands have 2 bytes following except for SysEx messages, be let's hope nobody sends them to us.");
				end
			end
			1: // Read Note number
			begin
				frequencyIndex <= midiByte[6:0];
				readState <= readState + 1; // Move to velocity byte
			end
			2: // Read velocity
			begin
				if (midiByte == 0 || noteOff == 1) begin
					// 0-velocity note press or note-off message received
					velocity <= 0;
					playing <= 0;
				end
				else begin
					velocity <= midiByte[6:0];
					playing <= 1;
				end
				
				readState <= 0; // Wait for next command
			end
			3: readState <= readState + 1; // Skip 2 bytes (this and the next one)
			4: readState <= 0; // Skip 1 byte (only this byte)
			default: readState <= 0;
		endcase
	end
	
	assign outPlaying = playing;
	assign outVelocity = velocity;
	assign outFrequencyIndex = frequencyIndex;

endmodule
