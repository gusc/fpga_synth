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


/* Filter calculation

Using butterworth filters
y - output sample
x - input sample

Recurrence relation:
y[n] = (  
		@finite response part: a coefficients in butterworth
			a1 * x[n- 8])
     + ( a2 * x[n- 7])
     + ( a3 * x[n- 6])
     + ( a4 * x[n- 5])
     + ( a5 * x[n- 4])
     + ( a6 * x[n- 3])
     + ( a7 * x[n- 2])
     + ( a8 * x[n- 1])
     + ( a9 * x[n- 0])
		@infinite response part: b coefficients in butterworth
     + ( b1 * y[n- 8])
     + ( b2 * y[n- 7])
     + ( b3 * y[n- 6])
     + ( b4 * y[n- 5])
     + ( b5 * y[n- 4])
     + ( b6 * y[n- 3])
     + ( b7 * y[n- 2])
     + ( b8 * y[n- 1])
*/
module ConvolutionFilter(
	input signed [11:0] inSample,
	input inSampleReady,
	
	// Filter types: [IIR, X,X,X]
	// No filter			- 0000
	// low pass FIR		- 0001
	// high pass FIR		- 0010
	// band pass FIR		- 0011
	// band reject FIR	- 0100
	// Moving average		- 0101
	// low pass IIR		- 1001
	// hight pass IIR		- 1010
	input [3:0] inFilterType,
	
	output [11:0] outSample
);
	localparam avgFilterSampleSpan = 16;
	localparam singleCutoffSampleSpan = 8;
	localparam singleCutoffIIRSampleSpan = 7;
	localparam multiCutoffSampleSpan = 17;
	
	localparam sampleSize = 12;
	localparam bufferedSamples = 20;
	
	reg [sampleSize * singleCutoffIIRSampleSpan - 1:0] IIRBuffer = 0;// FIFO buffer of multiple sample outs from filters
	reg [sampleSize * bufferedSamples - 1:0] sampleBuffer = 0;// FIFO buffer of multiple samples
	reg signed [sampleSize - 1:0] sample = 0;// Resulting sample
	reg signed [sampleSize - 1:0] tempSample = 0;// buffer for operating with one sample from sample buffer
	reg signed [64:0] sampleSum;
	reg signed [64:0] sampleIIRSum;
	
	integer i;
	integer j;
	integer bitIter;
	
	// Static FIR filters
	// seventh order
	reg signed [sampleSize - 1:0] filterLowPass500[singleCutoffSampleSpan - 1:0];
	reg signed [sampleSize - 1:0] filterHighPass500[singleCutoffSampleSpan - 1:0];
	// eight order
	reg signed [sampleSize - 1:0] filterBandPass500to2220[multiCutoffSampleSpan - 1:0];
	reg signed [sampleSize - 1:0] filterBandReject500to2220[multiCutoffSampleSpan - 1:0];
	
	// Static IIR additions
	reg signed [sampleSize - 1:0] IIRfilterLowPass500[singleCutoffSampleSpan - 1:0];
	reg signed [sampleSize - 1:0] IIRfilterHighPass500[singleCutoffSampleSpan - 1:0];
	
	initial begin
		// Butterworth coefficients claculated by: https://www-users.cs.york.ac.uk/~fisher/mkfilter/trad.html
		//######## FIR filters ########
		// Low pass
		filterLowPass500[0] = 1; // n-7
		filterLowPass500[1] = 7;
		filterLowPass500[2] = 21;
		filterLowPass500[3] = 35;
		filterLowPass500[4] = 35;
		filterLowPass500[5] = 21;
		filterLowPass500[6] = 7;
		filterLowPass500[7] = 1; // n-0
		
		// High pass
		filterHighPass500[0] = -1; // n-7
		filterHighPass500[1] = 7;
		filterHighPass500[2] = -21;
		filterHighPass500[3] = 35;
		filterHighPass500[4] = -35;
		filterHighPass500[5] = 21;
		filterHighPass500[6] = -7;
		filterHighPass500[7] = 1; // n-0
		
		// Band pass
		filterBandPass500to2220[0] = 1; // n-16
		filterBandPass500to2220[1] = 0; 
		filterBandPass500to2220[2] = -8; 
		filterBandPass500to2220[3] = 0; 
		filterBandPass500to2220[4] = 28;
		filterBandPass500to2220[5] = 0; 
		filterBandPass500to2220[6] = -56;
		filterBandPass500to2220[7] = 0;
		filterBandPass500to2220[8] = 70; 
		filterBandPass500to2220[9] = 0; 
		filterBandPass500to2220[10] = -56; 
		filterBandPass500to2220[11] = 0; 
		filterBandPass500to2220[12] = 28; 
		filterBandPass500to2220[13] = 0; 
		filterBandPass500to2220[14] = -8; 
		filterBandPass500to2220[15] = 0;
		filterBandPass500to2220[16] = 1; // n-0
		
		// Band reject
		filterBandReject500to2220[0] = 1; // n-16
		filterBandReject500to2220[1] = -15; 
		filterBandReject500to2220[2] = 117; 
		filterBandReject500to2220[3] = -543; 
		filterBandReject500to2220[4] = 1755;
		filterBandReject500to2220[5] = -4190; 
		filterBandReject500to2220[6] = 7652;
		filterBandReject500to2220[7] = -10908;
		filterBandReject500to2220[8] = 12262; 
		filterBandReject500to2220[9] = -10908; 
		filterBandReject500to2220[10] = 7652; 
		filterBandReject500to2220[11] = -4190; 
		filterBandReject500to2220[12] = 1755; 
		filterBandReject500to2220[13] = -543; 
		filterBandReject500to2220[14] = 117; 
		filterBandReject500to2220[15] = -15;
		filterBandReject500to2220[16] = 1; // n-0
		
		//####### IIR additions ########
		// Low pass
		IIRfilterLowPass500[0] = 0; // n-7
		IIRfilterLowPass500[1] = -5;
		IIRfilterLowPass500[2] = 16;
		IIRfilterLowPass500[3] = -29;
		IIRfilterLowPass500[4] = 30;
		IIRfilterLowPass500[5] = -19;
		IIRfilterLowPass500[6] = 6; // n-1
		//IIRfilterLowPass500[7] = 0;
		
		// High pass
		IIRfilterLowPass500[0] = 0; // n-7
		IIRfilterLowPass500[1] = -5;
		IIRfilterLowPass500[2] = 16;
		IIRfilterLowPass500[3] = -29;
		IIRfilterLowPass500[4] = 30;
		IIRfilterLowPass500[5] = -19;
		IIRfilterLowPass500[6] = 6;
		//IIRfilterLowPass500[7] = 1;
		
	end
	
	always @(posedge inSampleReady) begin
		sampleBuffer = sampleBuffer << 12;
		sampleBuffer[11:0] = inSample;
		sampleSum = 0;
		sampleIIRSum = 0;
		bitIter = 0;
		
		if(inFilterType == 4'b0000) begin // No filter applied
			sample = inSample;
		end
		else if (inFilterType == 4'b0001 || inFilterType == 4'b1001 || inFilterType == 4'b0010 || inFilterType == 4'b1010) begin // Static low / high pass FIR filters
			for(i = 0; i < singleCutoffSampleSpan; i = i + 1) begin
				// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
				for(j = 0; j < sampleSize; j = j + 1) begin
					tempSample[j] = sampleBuffer[bitIter];
					bitIter = bitIter + 1;
				end
				if(inFilterType == 4'b0001) begin
					tempSample = tempSample * filterLowPass500[i];
				end
				else if (inFilterType == 4'b0010) begin // high pass FIR filter
					tempSample = tempSample * filterHighPass500[i];
				end
				sampleSum = sampleSum + tempSample;
			end
			// Normalize samples, cause they may get bigger than actual 12 bit value
			sampleSum = sampleSum / 128;
			
			IIRBuffer = IIRBuffer << 12;
			IIRBuffer[11:0] = sampleSum;
			
			// Calculate IIR
			if(inFilterType == 4'b1001 || inFilterType == 4'b1010) begin
				bitIter = 0;
				for(i = 0; i < singleCutoffIIRSampleSpan; i = i + 1) begin
					// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
					for(j = 0; j < sampleSize; j = j + 1) begin
						tempSample[j] = sampleBuffer[bitIter];
						bitIter = bitIter + 1;
					end
					if(inFilterType == 4'b0001) begin
						tempSample = tempSample * IIRfilterLowPass500[i];
					end
					else if (inFilterType == 4'b0010) begin // high pass FIR filter
						tempSample = tempSample * IIRfilterHighPass500[i];
					end
					sampleIIRSum = sampleIIRSum + tempSample;
				end
				sampleIIRSum = sampleIIRSum / 128;
				sample = sampleSum + sampleIIRSum;
			end	
			else begin
				sample = sampleSum;
			end
		end 
		else if (inFilterType == 4'b0011 || inFilterType == 4'b0100) begin // Static band pass / reject FIR filters
			for(i = 0; i < multiCutoffSampleSpan; i = i + 1) begin
				// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
				for(j = 0; j < sampleSize; j = j + 1) begin
					tempSample[j] = sampleBuffer[bitIter];
					bitIter = bitIter + 1;
				end
				if(inFilterType == 4'b0011) begin
					tempSample = tempSample * filterBandPass500to2220[i];
				end
				else if (inFilterType == 4'b0100) begin // high pass FIR filter
					tempSample = tempSample * filterBandReject500to2220[i];
				end
				sampleSum = sampleSum + tempSample;
			end
			// Normalize samples, cause they may get bigger than actual 12 bit value
			sample = sampleSum / 128;
		end 
		else if (inFilterType == 4'b0101) begin // Moving Average filter
			for(i = 0; i < avgFilterSampleSpan; i = i + 1) begin
				// In Verilog the range must be bounded by constant expressions, so copy bit by bit, could use mask instead
				for(j = 0; j < sampleSize; j = j + 1) begin
					tempSample[j] = sampleBuffer[bitIter];
					bitIter = bitIter + 1;
				end
				sampleSum = sampleSum + tempSample;
			end
			sample = sampleSum / avgFilterSampleSpan;
		end
		else begin // INVALID type
			sample = 0;
		end
	end
	
	assign outSample = sample;
endmodule
