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
	input [11:0] inSample,
	input inSampleReady,
	
	output [11:0] outSample
);
	//localparam kernelType = 0;
	localparam sampleSize = 12;
	localparam bufferedSamples = 512;
	localparam bufferSize = bufferedSamples * sampleSize;
	
	reg [bufferSize:0] sampleBuffer;// FIFO buffer of multiple samples
	reg [11:0] sample = 0;// Resulting sample
	reg [11:0] tempSample;// buffer for operating with one sample from sample buffer
	reg [64:0] sampleSum;
	
	integer i;
	integer j;
	integer bitIter;
	
	always @(posedge inSampleReady) begin
		sampleBuffer = sampleBuffer << 12;
		sampleBuffer[11:0] = inSample;
		
		sample = 0;
		bitIter = 0;
		for(i = 0; i < bufferedSamples; i = i + 1) begin
			// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
			for(j = 0; j < sampleSize; j = j + 1) begin
				tempSample[j] = sampleBuffer[bitIter];
				bitIter = bitIter + 1;
			end
			sampleSum = sampleSum + tempSample;
		end
		sampleSum = sampleSum / bufferedSamples;
	end
	
	assign outSample = sample;
endmodule
