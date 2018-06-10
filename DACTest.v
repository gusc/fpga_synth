`timescale 1ns / 1ps

module DACTest;

	// Input
	reg IN_CLOCK;
	reg IN_RESET;
	reg [11:0]IN_BITS;
	
	// Outputs
	wire OUT_SPI_MOSI;
	wire OUT_SPI_SCK;
	wire OUT_DAC_CS;
	wire OUT_DAC_CLR;
	wire [4:0]OUT_STATE;
	wire [31:0]OUT_WRITE_BIT;

	DAC uut (
		.IN_CLOCK(IN_CLOCK),
		.IN_RESET(IN_RESET),
		.IN_BITS(IN_BITS),

		.OUT_SPI_SCK(OUT_SPI_SCK),
		.OUT_SPI_MOSI(OUT_SPI_MOSI),
		
		.OUT_DAC_CS(OUT_DAC_CS), 
		.OUT_DAC_CLR(OUT_DAC_CLR),
	
		.OUT_STATE(OUT_STATE),
		.OUT_WRITE_BIT(OUT_WRITE_BIT)
	);

	initial begin
		IN_RESET = 0;
		IN_CLOCK = 0;
		IN_BITS = 4'b1111;
	end
      
	always begin
		#5 IN_CLOCK = ~IN_CLOCK;
	end
endmodule
