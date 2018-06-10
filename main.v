`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LU
// Engineer: Arturs, Guntars, Gusts, Tomass 
// 
// Create Date:    13:41:59 05/16/2018 
// Design Name:    fpga_synth
// Module Name:    main 
// Project Name:   Masterpiece
// Target Devices: Spartan 3E Starter Kit + FX2-BB
// Tool versions: 
// Description: MIDI to audio synthesizer
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main(
		output SYNC,
		output DOUTA,
		output DOUTB,
		output SCLK,
		input CLK_50MHZ,
		
		input MIDI_IN,
		output [7:0] DBG_LED,
		// DAC
		output SPI_MOSI,
		output SPI_SCK,
		output DAC_CS,
		output DAC_CLR
    );
	// MIDI INPUT
	wire[7:0] midiByte;   			// 8-bit MIDI byte
	wire midiReady;       			// MIDI byte successfully received
	MIDIIn midi(
		.clock(CLK_50MHZ),
		.uartStream(MIDI_IN),
		.byteOutput(midiByte),
		.byteOutputReady(midiReady)
	);
		
	// MIDI PARSER
	wire[6:0] midiFrequencyIndex; // table index for frequency_step of 24bit frequency * 1000
	wire[6:0] sampleVelocity;    	// 0-127
	wire samplePlaying;        		// Is MIDI playback active?
	wire[6:0] envAttack;
	wire[6:0] envRelease;
	wire[6:0] filterFreq;
	
	MIDIParse parser(
		.midiByte(midiByte),
		.midiReady(midiReady),
		.outFrequencyIndex(midiFrequencyIndex),
		.outVelocity(sampleVelocity),
		.outPlaying(samplePlaying),
		.outEnvAttack(envAttack),
		.outEnvRelease(envRelease),
		.outFilterFreq(filterFreq)
	);
	
	// MIDI Debug
	reg[7:0] dbgData;
	always @(posedge CLK_50MHZ) begin
		if (samplePlaying == 1) begin
			dbgData = filterFreq;
		end
		else begin
			dbgData = 8'h0;
		end
	end
	assign DBG_LED = dbgData;
	
	// SAMPLE GENERATOR
	wire sampleClockCE; // Sampling Clock Enable flag
	wire [11:0] filterSample;
	SampleGenerator sampleGen(
		.inCLK(CLK_50MHZ),
		.inSampleClockCE(sampleClockCE),
		.inMidiFrequencyIndex(midiFrequencyIndex),
		.outSample(filterSample)
	);
	
	// CONVOLUTIONAL FILTER
	wire [11:0] envelopeSample;
	ConvolutionFilter filter(
		.inSample(filterSample),
		.inSampleReady(sampleClockCE),
		.outSample(envelopeSample)
	);
	
	// ENVELOPE FOLLOWER
	wire [11:0] dacSample;
	EnvelopeFollower envelope(
		.inSample(envelopeSample),
		.inSampleReady(sampleClockCE),
		.inIsPlaying(samplePlaying),
		.inVelocity(sampleVelocity),
		.outSample(dacSample)
	);
	
	// for testing purposes slow clock generator
	// creates clock which waits 0.1ms for a tick
	reg SLOW_CLOCK = 0;
	integer SLOW_CLOCK_COUNTER = 0;
	
	always @(posedge CLK_50MHZ) begin
		if (SLOW_CLOCK_COUNTER == 2500000) begin //2500000
			SLOW_CLOCK_COUNTER <= 0;
			SLOW_CLOCK <= ~SLOW_CLOCK;
		end else begin
			SLOW_CLOCK_COUNTER <= SLOW_CLOCK_COUNTER + 1;
		end
	end

	// for testing purposes slow sample generator
	// data must be written in when DAC_CS is one
	// IN_CLOCK can be an arbitrary clock it just represents speed
	// at which data is written in dac
	
	// IN_RESET can always be 0
	// it can be used to terminate current data transfer to dac
	// when RESET is turned to 1, DAC_CS will instantly move to posedge
	integer STEP = 100;
	reg TREND = 0;
	reg [11:0]BITS = 0;
	always @(posedge DAC_CS) begin
		if (TREND == 1) begin
			BITS = BITS + STEP;
		end else begin
			BITS = BITS - STEP;
		end
		
		if (TREND == 1 && BITS > 12'hFFF - STEP) begin
			TREND = 0;
		end else if (TREND == 0 && BITS < STEP) begin
			TREND = 1;
		end
	end

	reg reset = 0;
	DAC out(
		.IN_CLOCK(SLOW_CLOCK),
		.IN_RESET(IN_RESET),
		.IN_BITS(BITS),

		.OUT_SPI_SCK(SPI_SCK),
		.OUT_SPI_MOSI(SPI_MOSI),
		
		.OUT_DAC_CS(DAC_CS), 
		.OUT_DAC_CLR(DAC_CLR)
	);
	
	assign IN_RESET = reset;
endmodule
