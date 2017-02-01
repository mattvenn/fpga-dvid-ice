`default_nettype none
//`define 50M_PLL
`define 126M_PLL // correct for 25mhz vga clock
//`define 200M_PLL

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
    // 50 mhz, vga_clk is 10mhz
    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .PLLOUT_SELECT("GENCLK"),
        `ifdef 50M_PLL
        .DIVR(4'b0000),
        .DIVF(7'b1000010),
        .DIVQ(3'b100),
        .FILTER_RANGE(3'b001)
        `endif
        `ifdef 126M_PLL
        .DIVR(4'b0000),
        .DIVF(7'b1010011),
        .DIVQ(3'b011),
        .FILTER_RANGE(3'b001)
        `endif
        `ifdef 200M_PLL
        .DIVR(4'b0000),
        .DIVF(7'b1000010),
        .DIVQ(3'b010),
        .FILTER_RANGE(3'b001)
        `endif
    ) uut (
//        .LOCK(lock),
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk),
        .PLLOUTCORE(clkx5)
    );

    wire vga_clk;

    assign PIO0[0] = hsync;
    assign PIO0[1] = vsync;
    assign PIO0[2] = blank;
    assign PIO0[3] = vga_clk;
    assign PIO0[4] = clkx5;
    assign PIO0[5] = clk;

    clk_divn clockdiv(.clk(clkx5), .clk_out(vga_clk));

    vga vga_test(.clk(vga_clk), .hsync(hsync), .vsync(vsync), .blank(blank), .red(red), .green(green), .blue(blue));

    dvid dvid_test(.clk(vga_clk), .clkx5(clkx5), .hsync(hsync), .vsync(vsync), .blank(blank), .red(red), .green(green), .blue(blue), .hdmi_p(PMOD[0:3]), .hdmi_n(PMOD[4:7]));


endmodule
