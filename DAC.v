`timescale 1ns / 1ps

module DAC(
	// speed at which bits are written in dac, must be slower than 50mhz
	input IN_CLOCK,
	// set one to reset dac and 0 to start writing
	input IN_RESET,
	// actual value for dac output
	input [11:0]IN_BITS,
	// dac clock
	output OUT_SPI_SCK,
	// dac output
    output OUT_SPI_MOSI,
	// dac write flag
    output OUT_DAC_CS,
	// dac clear flag
    output OUT_DAC_CLR,
	// used by simulation to debug
	output [4:0]OUT_STATE,
	// used by simulation to debug
	output [31:0]OUT_WRITE_BIT
);

reg SPI_MOSI = 0;
reg DAC_CS = 1;
reg DAC_CLR = 0;
reg SPI_SCK = 0;

reg [31:0]BITS = 0;
reg [4:0] STATE = 1;

// 8-bit don't care 
// 4-bit command
// 4-bit dac pin 
// 12-bit dac value (these will be overriden from IN_BITS)
// 4-bit don't care
// currently this is hardcoded to:
// command: write and update dac (0011)
// pin: pin D (0011) 2.5v max
integer BASE_BITS = 32'b10000000001100110000000000000001; 
integer CURRENT_BIT = 32;

always @(posedge IN_CLOCK) begin
	if (IN_RESET == 1) begin
		DAC_CS = 1;
		DAC_CLR = 0;
		STATE = 1;
	end else begin
		case (STATE)
		1: begin
			DAC_CS = 1;
			DAC_CLR = 1;
			
			SPI_SCK = 0;
			SPI_MOSI = 0;
			BITS = 0;
			CURRENT_BIT = 0;
			STATE = 2;
		end
		2: begin
			BITS = BASE_BITS | (IN_BITS << 4);
			CURRENT_BIT = 32;
			STATE = 3;
		end
		3: begin
			DAC_CS = 0;
			SPI_SCK = 0;
			SPI_MOSI = BITS[CURRENT_BIT - 1];
			CURRENT_BIT = CURRENT_BIT - 1;
			STATE = 4;
		end
		4: begin			
			if (CURRENT_BIT > 0) begin
				STATE = 3;
			end else begin
				STATE = 5;
			end
			
			SPI_SCK = 1;
		end
		5: begin
			SPI_SCK = 0;
			STATE = 6;
		end
		6: begin
			DAC_CS = 1;
			SPI_SCK = 1;
			STATE = 1;
		end
		default: begin
			DAC_CS = 1;
			DAC_CLR = 1;
			SPI_SCK = 0;
			SPI_MOSI = 0;
			STATE = 1;
		end
		endcase
	end
end

assign OUT_SPI_MOSI = SPI_MOSI;
assign OUT_SPI_SCK = SPI_SCK;

assign OUT_DAC_CS = DAC_CS;
assign OUT_DAC_CLR = DAC_CLR;

// debugging
assign OUT_STATE = STATE;
assign OUT_WRITE_BIT = BITS;

endmodule

