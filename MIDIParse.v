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
		output outPlaying,
		output [6:0] outEnvAttack,
		output [6:0] outEnvRelease,
		output [6:0] outFilterFreq
    );

	reg[3:0] byteNumber = 0; // command, note, velocity, reserved steps to skip all other MIDI commands
	reg[3:0] messageType = 0; // note on, note off, controll message, other
	reg[6:0] controlNumber = 0; // control change number
	
	// Output is 24 bit integer, because highest frequency is 4186Hz * 1000
	reg[6:0] frequencyIndex = 0;
	reg[6:0] velocity = 0;
	reg playing = 0;
	reg[6:0] envAttack = 0;
	reg[6:0] envRelease = 0;
	reg[6:0] filterFreq = 0;
	
	always @(posedge midiReady) begin
		case (byteNumber)
			0: // Read MIDI command message
			begin
				$display("8'hF0 => %b", 8'hF0);
				$display("midi_byte & 8'hF0 => %b", midiByte & 8'hF0);
				if ((midiByte & 8'hF0) == 8'b10010000) begin
					// Note-on message (all channel)
					messageType <= 1;
					byteNumber <= byteNumber + 1;
					$display("midi_byte & 8'hF0 == 8'b10010000: Note-on message (all channel)");
				end
				else if ((midiByte & 8'hF0) == 8'b10000000) begin
					// Note-off message (all channels)
					messageType <= 2;
					byteNumber <= byteNumber + 1;
					$display("midi_byte & 8'hF0 == 8'b10000000: Note-off message (all channels)");
				end
				else if ((midiByte & 8'hB0) == 8'b10110000) begin
					// Control change message (all channels)
					messageType <= 3;
					byteNumber <= byteNumber + 1;
					$display("midi_byte & 8'hB0 == 8'b10110000: Control change message (all channels)");
				end
				else if (((midiByte & 8'hF0) == 8'b11000000)
						|| ((midiByte & 8'hF0) == 8'b11010000)) begin
					// Program change and Channel pressure messages have 
					// single byte data.
					messageType <= 0;
					byteNumber <= 4;
					$display("midi_byte & 8'hF0 == 8'b11000000 || midi_byte & 8'hF0 == 8'b11010000: Program change and Channel pressure messages have single byte data.");
				end
				else begin
					// Rest of standard commands have 2 bytes following
					// except for SysEx messages, be let's hope nobody sends
					// them to us.
					messageType <= 0;
					byteNumber <= 3;
					$display("else: Rest of standard commands have 2 bytes following except for SysEx messages, be let's hope nobody sends them to us.");
				end
			end
			1: // Read second message byte
			begin
				if (messageType == 1 || messageType == 2) begin
					// Note mesage - read note number
					frequencyIndex <= midiByte[6:0];
				end
				else if (messageType == 3) begin
					// Control change message - read control number
					controlNumber <= midiByte[6:0];
				end
				byteNumber <= byteNumber + 1; // Move to velocity byte
			end
			2: // Read third message byte
			begin
				if ((messageType == 1 && midiByte == 0) || messageType == 2) begin
					// 0-velocity note press or note-off message received
					velocity <= 0;
					playing <= 0;
				end
				else if (messageType == 1) begin
					// note-on message - read velocity
					velocity <= midiByte[6:0];
					playing <= 1;
				end
				else if (messageType == 3) begin
					// control change message - read control value
					if (controlNumber == 73) begin
						// Envelope Attack
						envAttack <= midiByte[6:0];
					end
					else if (controlNumber == 72) begin
						// Envelope Release
						envRelease <= midiByte[6:0];
					end
					else if (controlNumber == 74) begin
						// Filter frequency (brightness by MIDI standard)
						filterFreq <= midiByte[6:0];
					end
				end
				
				byteNumber <= 0; // Wait for next command
			end
			3: byteNumber <= byteNumber + 1; // Skip 2 bytes (this and the next one)
			4: byteNumber <= 0; // Skip 1 byte (only this byte)
			default: byteNumber <= 0;
		endcase
	end
	
	assign outPlaying = playing;
	assign outVelocity = velocity;
	assign outFrequencyIndex = frequencyIndex;
	assign outEnvAttack = envAttack;
	assign outEnvRelease = envRelease;
	assign outFilterFreq = filterFreq;

endmodule
