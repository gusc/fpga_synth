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
// Description: MIDI input module, handles raw UART data 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//   https://www.tigoe.com/pcomp/code/communication/midi/
//   https://learn.sparkfun.com/tutorials/midi-tutorial/hardware--electronic-implementation
//
//////////////////////////////////////////////////////////////////////////////////
module MIDIIn(
	input clock,
	input uartStream,
	output [7:0] byteOutput,
	output byteOutputReady
    );

	reg[10:0] clkCounter = 0; // max 2048
	reg[3:0] bitCounter = 0;  // max 16
	reg[7:0] byteInput = 0;
	reg byteReady = 0;   // Ready to send byte
	reg startBit = 0;    // Start bit has been received
	reg endBit = 1;      // End bit has been received
	
	// 31,250 bits per second data rate
	// 1 bit is sent for 1600 useconds

	always @(posedge clock) begin
		if (startBit == 1) begin
			if (bitCounter == 8) begin
				endBit <= uartStream;
			end
			else begin
				byteInput[bitCounter] <= uartStream;
			end
		end
		else begin
			startBit <= uartStream;
			byteReady <= 0;
		end
		
		clkCounter = clkCounter + 1;
		if (clkCounter == 800) begin
			clkCounter = 0;
			if (startBit == 1) begin
				bitCounter = bitCounter + 1;
			end
		end
		if (bitCounter == 9 && endBit == 0) begin
			bitCounter = 0;
			startBit <= 0;
			endBit <= 1;
			byteReady <= 1;
		end
	end

	assign byteOutput = byteInput;
	assign byteOutputReady = byteReady;
	
endmodule
