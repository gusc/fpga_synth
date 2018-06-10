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
	reg startBit = 1;    // Start bit has been received
	reg endBit = 0;      // End bit has been received
	reg readBit = 0;     // When 1 we're ready to read the a bit
	reg readByte = 0;    // When 1 we're synced and ready to read the byte
	//reg delayEnd = 0;    // When 1 we've reached the end, we just wait till byte ends
	
	// 31,250 bits per second data rate
	// 1 bit is sent for 32 useconds which is 1600 cycles @ 50Mhz
	
	// Signal: (idle, start bit = 0, 8 data bits, end bit = 1)
	//    _ _       _     _   _ _ _ _
	//       |_ _ _| |_ _| |_| 
	//    i i s 0 1 2 3 4 5 6 7 e i i

	always @(posedge clock) begin
		// Sync with the UART message
		if (readByte == 0 && uartStream == 0) begin
			// UART signal dropped, that means we might have hit a start bit
			readByte <= 1;
			readBit <= 1;
			byteReady <= 0;
			clkCounter = 0;
			bitCounter = 0;
		end
		
		// Start counter when we're synced up
		if (readByte == 1) begin
			clkCounter = clkCounter + 1;
			if (clkCounter == 200) begin
				// Wait some 200 cycles for the signal to stabilize
				readBit <= 1;
			end
			else if (clkCounter == 1600) begin
				// Each bit will take 1600 50MHz cycles (32us) to complete
				clkCounter = 0;
				bitCounter = bitCounter + 1;
			end
		end
		
		// Read a single bit
	    if (readBit == 1) begin
			if (startBit == 0) begin
				if (bitCounter == 9) begin
					endBit <= uartStream;
				end
				else if (bitCounter < 9) begin
					byteInput[bitCounter - 1] <= uartStream;
				end
			end
			else begin
				startBit <= uartStream;
			end
			// Done reading bit, wait for the next one
			readBit <= 0;
		end
		
		if (bitCounter == 9 && startBit == 0) begin
			// Last bit, should be low, only then we say taht the byte
			// is ready, otherwise we reset
			if (endBit == 1) begin
				byteReady <= 1;
			end
		end
		else if (bitCounter == 10) begin
			// Reset the state and wait for the next byte
			readBit <= 0;
			readByte <= 0;
			startBit <= 1;
			endBit <= 0;
		end
	end

	assign byteOutput = byteInput;
	assign byteOutputReady = byteReady;
	
endmodule
