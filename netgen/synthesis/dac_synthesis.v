////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: dac_synthesis.v
// /___/   /\     Timestamp: Mon May 28 18:22:19 2018
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -filter /home/osboxes/Documents/fpga_synth/iseconfig/filter.filter -intstyle ise -insert_glbl true -w -dir netgen/synthesis -ofmt verilog -sim dac.ngc dac_synthesis.v 
// Device	: xc3s500e-4-fg320
// Input file	: dac.ngc
// Output file	: /home/osboxes/Documents/fpga_synth/netgen/synthesis/dac_synthesis.v
// # of Modules	: 1
// Design Name	: dac
// Xilinx        : /opt/Xilinx/14.7/ISE_DS/ISE/
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module dac (
  SPI_SCL, CLK_50MHZ, SPI_MOSI
);
  output SPI_SCL;
  input CLK_50MHZ;
  output [31 : 0] SPI_MOSI;
  wire CLK_50MHZ_BUFGP_1;
  wire SPI_MOSI_0_OBUF_34;
  wire SPI_MOSI_22_OBUF_35;
  wire clock_37;
  GND   XST_GND (
    .G(SPI_MOSI_22_OBUF_35)
  );
  VCC   XST_VCC (
    .P(SPI_MOSI_0_OBUF_34)
  );
  OBUF   SPI_SCL_OBUF (
    .I(clock_37),
    .O(SPI_SCL)
  );
  OBUF   SPI_MOSI_31_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[31])
  );
  OBUF   SPI_MOSI_30_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[30])
  );
  OBUF   SPI_MOSI_29_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[29])
  );
  OBUF   SPI_MOSI_28_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[28])
  );
  OBUF   SPI_MOSI_27_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[27])
  );
  OBUF   SPI_MOSI_26_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[26])
  );
  OBUF   SPI_MOSI_25_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[25])
  );
  OBUF   SPI_MOSI_24_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[24])
  );
  OBUF   SPI_MOSI_23_OBUF (
    .I(SPI_MOSI_22_OBUF_35),
    .O(SPI_MOSI[23])
  );
  OBUF   SPI_MOSI_22_OBUF (
    .I(SPI_MOSI_22_OBUF_35),
    .O(SPI_MOSI[22])
  );
  OBUF   SPI_MOSI_21_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[21])
  );
  OBUF   SPI_MOSI_20_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[20])
  );
  OBUF   SPI_MOSI_19_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[19])
  );
  OBUF   SPI_MOSI_18_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[18])
  );
  OBUF   SPI_MOSI_17_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[17])
  );
  OBUF   SPI_MOSI_16_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[16])
  );
  OBUF   SPI_MOSI_15_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[15])
  );
  OBUF   SPI_MOSI_14_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[14])
  );
  OBUF   SPI_MOSI_13_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[13])
  );
  OBUF   SPI_MOSI_12_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[12])
  );
  OBUF   SPI_MOSI_11_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[11])
  );
  OBUF   SPI_MOSI_10_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[10])
  );
  OBUF   SPI_MOSI_9_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[9])
  );
  OBUF   SPI_MOSI_8_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[8])
  );
  OBUF   SPI_MOSI_7_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[7])
  );
  OBUF   SPI_MOSI_6_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[6])
  );
  OBUF   SPI_MOSI_5_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[5])
  );
  OBUF   SPI_MOSI_4_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[4])
  );
  OBUF   SPI_MOSI_3_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[3])
  );
  OBUF   SPI_MOSI_2_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[2])
  );
  OBUF   SPI_MOSI_1_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[1])
  );
  OBUF   SPI_MOSI_0_OBUF (
    .I(SPI_MOSI_0_OBUF_34),
    .O(SPI_MOSI[0])
  );
  FDR #(
    .INIT ( 1'b0 ))
  clock (
    .C(CLK_50MHZ_BUFGP_1),
    .D(SPI_MOSI_0_OBUF_34),
    .R(clock_37),
    .Q(clock_37)
  );
  BUFGP   CLK_50MHZ_BUFGP (
    .I(CLK_50MHZ),
    .O(CLK_50MHZ_BUFGP_1)
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

