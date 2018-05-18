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
	input clk,
	input uart,
	output [7:0] byte_output,
	output output_ready
    );

	reg[10:0] clk_counter = 0; // max 2048
	reg[3:0] bit_counter = 0;  // max 16
	reg[7:0] byte_input = 0;
	reg[0:0] byte_ready = 0;   // Ready to send byte
	reg[0:0] startbit = 0;     // Start bit has been received
	reg[0:0] endbit = 1;       // End bit has been received
	
	// 31,250 bits per second data rate
	// 1 bit is sent for 1600 useconds

	always @(posedge clk) begin
		if (startbit == 1) begin
			if (bit_counter == 8) begin
				endbit <= uart;
			end
			else begin
				byte_input[bit_counter] <= uart;
			end
		end
		else begin
			startbit <= uart;
			byte_ready <= 0;
		end
		
		clk_counter = clk_counter + 1;
		if (clk_counter == 800) begin
			clk_counter = 0;
			if (startbit == 1) begin
				bit_counter = bit_counter + 1;
			end
		end
		if (bit_counter == 9 && endbit == 0) begin
			bit_counter = 0;
			startbit <= 0;
			endbit <= 1;
			byte_ready <= 1;
		end
	end

	assign byte_output = byte_input;
	assign output_ready = byte_ready;
	
endmodule
