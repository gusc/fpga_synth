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
		//output SYNC,
		//output DOUTA,
		//output DOUTB,
		output SCLK,
		input CLK_50MHZ,
		// MIDI UART
		input MIDI_IN,
		// DEBUGGING OUTPUT
		output [7:0] DBG_LED,
		// SWITCHES FOR FILTER,
		input [2:0] SW_FILTER,
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
	wire[6:0] sampleVelocity;     // 0-127
	wire samplePlaying;        	  // Is MIDI playback active?
	wire[6:0] envAttack;
	wire[6:0] envRelease;
	wire[6:0] filterFreq;
	// Sample generation wave mode
	// 0 - Sine-wave (default)
	// 1 - Square-wave
	wire[1:0] waveMode;

	MIDIParse parser(
		.midiByte(midiByte),
		.midiReady(midiReady),
		.outFrequencyIndex(midiFrequencyIndex),
		.outVelocity(sampleVelocity),
		.outPlaying(samplePlaying),
		.outEnvAttack(envAttack),
		.outEnvRelease(envRelease),
		.outFilterFreq(filterFreq),
		.outWaveSel(waveMode)
	);
	
	// 44.1 KHZ OSCILLATOR
	wire clk_44100;
	Oscillator_44100 osc44100(
		.CLK_50MHZ(CLK_50MHZ),
		.CLK_44100HZ(clk_44100)
	);	
	
	// SAMPLE GENERATOR	
	wire [11:0] filterSample;
	wire outSampleReady;
	SampleGenerator sampleGen(
		.inCLK_50MHZ(CLK_50MHZ),
		.inSAMPLE_CLK(clk_44100),
		.inWaveMode(waveMode),
		.inMidiFrequencyIndex(midiFrequencyIndex),
		.outSample(filterSample),
		.outSampleReady(outSampleReady)
	);
	
	// CONVOLUTIONAL FILTER
	wire [11:0] envelopeSample;
	ConvolutionFilter filter(
		.inFilterType(SW_FILTER),
		.inSample(filterSample),
		.inSampleReady(outSampleReady),
		.outSample(envelopeSample)
	);
	
	// ENVELOPE FOLLOWER
	wire [11:0] dacSample;
	EnvelopeFollower envelope(
		.inSample(envelopeSample),
		.inSampleReady(outSampleReady),
		.inIsPlaying(samplePlaying),
		.inVelocity(sampleVelocity),
		.outSample(dacSample)
	);
	
	// DAC OUTPUT
	reg reset = 0;
	DAC out(
		.IN_CLOCK(CLK_50MHZ),
		.IN_RESET(IN_RESET),
		.IN_BITS(dacSample),

		.OUT_SPI_SCK(SPI_SCK),
		.OUT_SPI_MOSI(SPI_MOSI),
		
		.OUT_DAC_CS(DAC_CS), 
		.OUT_DAC_CLR(DAC_CLR)
	);
	assign IN_RESET = reset;
	
	// DEBUGGING
	//reg[7:0] dummy = 7'h7F;
	// Do something useful
	assign DBG_LED = envAttack;
	
endmodule
