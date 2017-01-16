`default_nettype none
module top (
	input  clk,
    output [7:0] PIO0,
    output [7:0] PMOD
);
    wire clkx5;
  wire hsync;
  wire vsync;
  wire blank;
  wire [2:0] red;
  wire [2:0] green;
  wire [2:0] blue;
    //PLL details http://www.latticesemi.com/view_document?document_id=47778
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        .DIVR(4'b0000),
        .DIVF(7'b1001111),
        .DIVQ(3'b100),
        .FILTER_RANGE(3'b100)
    ) uut (
//        .LOCK(lock),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk),
        .PLLOUTCORE(clkx5)
    );

    assign PIO0[0] = hsync;
    assign PIO0[1] = vsync;
    assign PIO0[3] = blank;
    assign PIO0[4] = clk;
    assign PIO0[5] = clkx5;

  vga vga_test(.clk(clk), .hsync(hsync), .vsync(vsync), .blank(blank), .red(red), .green(green), .blue(blue));

  dvid dvid_test(.clk(clk), .clkx5(clkx5), .hsync(hsync), .vsync(vsync), .blank(blank), .red(red), .green(green), .blue(blue), .hdmi_p(PMOD[0:3]), .hdmi_n(PMOD[4:7]));


endmodule
