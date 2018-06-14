`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Guntars Puzulis 
// 
// Create Date:    16:25:49 05/19/2018 
// Design Name: 
// Module Name:    ConvolutionFilter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ConvolutionFilter(
	input signed [11:0] inSample,
	input inSampleReady,
	
	// FIR Filter types:
	// averaged		- 000
	// low pass		- 001
	// high pass	- 010
	// band pass	- 011
	// band reject - 100
	// No filter 	- 101
	input [2:0] inFilterType,
	
	output [11:0] outSample
);
	localparam sampleSize = 12;
	localparam bufferedSamples = 8;
	
	reg [bufferedSamples * sampleSize - 1:0] sampleBuffer = 0;// FIFO buffer of multiple samples
	reg signed [11:0] sample = 0;// Resulting sample
	reg signed [11:0] tempSample = 0;// buffer for operating with one sample from sample buffer
	reg signed [64:0] sampleSum;
	
	integer i;
	integer j;
	integer bitIter;
	
	// Static filters
	reg signed [sampleSize - 1:0] filterLowPass500[bufferedSamples - 1:0];
	reg signed [sampleSize - 1:0] filterHighPass500[bufferedSamples - 1:0];
	
	initial begin
	
		// Low pass
		filterLowPass500[0] = 1;
		filterLowPass500[1] = 7;
		filterLowPass500[2] = 21;
		filterLowPass500[3] = 35;
		filterLowPass500[4] = 35;
		filterLowPass500[5] = 21;
		filterLowPass500[6] = 7;
		filterLowPass500[7] = 1;
		
		// High pass
		filterHighPass500[0] = -1;
		filterHighPass500[1] = 7;
		filterHighPass500[2] = -21;
		filterHighPass500[3] = 35;
		filterHighPass500[4] = -35;
		filterHighPass500[5] = 21;
		filterHighPass500[6] = -7;
		filterHighPass500[7] = 1;
		
	end
	
	always @(posedge inSampleReady) begin
		sampleBuffer = sampleBuffer << 12;
		sampleBuffer[11:0] = inSample;
		sampleSum = 0;
		bitIter = 0;
		
		if(inFilterType == 3'b000) begin // Moving Average filter=
			for(i = 0; i < bufferedSamples; i = i + 1) begin
				// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
				for(j = 0; j < sampleSize; j = j + 1) begin
					tempSample[j] = sampleBuffer[bitIter];
					bitIter = bitIter + 1;
				end
				sampleSum = sampleSum + tempSample;
			end
			sample = sampleSum / bufferedSamples;
		end
		else if (inFilterType <= 3'b100) begin // Static filters
			for(i = 0; i < bufferedSamples; i = i + 1) begin
				// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
				for(j = 0; j < sampleSize; j = j + 1) begin
					tempSample[j] = sampleBuffer[bitIter];
					bitIter = bitIter + 1;
				end
				if(inFilterType == 3'b001) begin
					tempSample = tempSample * filterLowPass500[i];
				end
				else if (inFilterType == 3'b010) begin // high pass FIR filter
					tempSample = tempSample * filterHighPass500[i];
				end
				/*else if (inFilterType == 3'b011) begin // band pass	- 011
					sample = 0;
				end
				else if (inFilterType == 3'b100) begin // band reject - 100
					sample = 0;
				end*/
				
				sampleSum = sampleSum + tempSample;
			end
			// Normalize samples, cause they may get bigger than actual 12 bit value
			sample = sampleSum / 128;
		end 
		else if (inFilterType == 3'b101) begin // No filter applied
			sample = inSample;
		end
		else begin // INVALID type
			sample = 0;
		end
	end
	
	assign outSample = sample;
endmodule
