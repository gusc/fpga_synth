`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arturs Valenieks
//
// Create Date:   15:54:15 05/26/2018
// Design Name:   sineWaveExample
// Module Name:   /home/osboxes/Documents/fpga_synth/sineWaveExampleTest.v
// Project Name:  fpga_synth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sineWaveExample
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sineWaveExampleTest;
    // Inputs
    reg Clk;

    // Outputs
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    sine_wave_gen uut (
        .Clk(Clk), 
        .data_out(data_out)
    );

    //Generate a clock with 10 ns clock period.
    initial Clk = 0;
    always #5 Clk = ~Clk;
    
endmodule

