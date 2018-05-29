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
	reg readBit = 0;     // Filter out raising and falling edges 
	
	// 31,250 bits per second data rate
	// 1 bit is sent for 1600 useconds
	
	// Signal: (start bit = 1, 8 data bits, end bit = 0)
	//        _     _     _   _ 
	//         |_ _| |_ _| |_| |_
	//        s 0 1 2 3 4 5 6 7 e

	always @(posedge clock) begin
	    if (readBit == 1) begin
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
			readBit = 0;
		end
		
		clkCounter = clkCounter + 1;
		if (clkCounter == 200) begin
			readBit = 1;
		end
		else if (clkCounter == 800) begin
			clkCounter = 0;
			if (startBit == 1) begin
				bitCounter = bitCounter + 1;
			end
		end
		if (bitCounter == 9) begin
			bitCounter = 0;
			if (endBit == 0) begin
				byteReady <= 1;
			end
			startBit <= 0;
			endBit <= 1;
		end
	end

	assign byteOutput = byteInput;
	assign byteOutputReady = byteReady;
	
endmodule
