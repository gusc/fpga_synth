`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:52 06/10/2018 
// Design Name: 
// Module Name:    Oscillator_44100 
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
module Oscillator_44100(
    CLK_50MHZ,
    CLK_44100HZ
);
// Source: https://www.edaboard.com/showthread.php?81965-Help-me-convert-convert-a-50-MHZ-clock-into-44-1-KHZ-clock&p=358693&viewfull=1#post358693
// === I/O ===
input CLK_50MHZ;
output reg CLK_44100HZ = 0;

// === HELPER VARIABLES ===
wire clkadcm, clka, locked;
reg [4:0] reset = 0;
wire clkb;
reg [9:0] count = 0;

// === 44100 HZ divider logic  ===
// Synthesize 50 MHz * 21/25 * 21/25 / 800 = 44100 Hz
DCM dcm1 (.CLKIN(CLK_50MHZ), .RST(1'b0), .CLKFX(clkadcm), .LOCKED(locked));
defparam dcm1.CLK_FEEDBACK       = "NONE";
defparam dcm1.CLKFX_MULTIPLY     = 21;
defparam dcm1.CLKFX_DIVIDE       = 25;
defparam dcm1.CLKIN_PERIOD       = 20.0;
defparam dcm1.DFS_FREQUENCY_MODE = "LOW";

BUFGMUX buf1 (.I0(clkadcm), .S(1'b0), .O(clka));

always @ (posedge clka)
    reset <= {reset,locked};

DCM dcm2 (.CLKIN(clka), .RST(~reset[4]), .CLKFX(clkb), .LOCKED());
defparam dcm2.CLK_FEEDBACK       = "NONE";
defparam dcm2.CLKFX_MULTIPLY     = 21;
defparam dcm2.CLKFX_DIVIDE       = 25;
defparam dcm2.CLKIN_PERIOD       = 23.8;
defparam dcm2.DFS_FREQUENCY_MODE = "LOW";

always @ (posedge clkb) begin
    count <= !count ? 799 : count - 1;
    CLK_44100HZ <= !count;
end

endmodule
