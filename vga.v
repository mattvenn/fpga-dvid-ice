/*
generate test pattern at 800 x 600 @ 60Hz

total pixels is 1056 x 628 @ 60Hz = 39.79MHz

Timings from :

* http://hamsterworks.co.nz/mediawiki/index.php/VGA_timings
* http://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml

code adapted from VHDL :

* http://hamsterworks.co.nz/mediawiki/index.php/FPGA_VGA
* http://hamsterworks.co.nz/mediawiki/index.php/Dvid_test#vga.vhd

MHz     40.00
ns      25.00

Horizontal Timing
800     h visible
40      front
128     sync
88      back
1056    whole
+       hsync

Vertical Timing

600     v visible
1       front
4       sync
23      back
628     whole
+       vsync
*/

`default_nettype none
module vga (
	input wire clk,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [2:0] blue,
    output reg hsync,
    output reg vsync,
    output reg blank
    );

    reg [10:0] hcounter = 0;
    reg [9:0] vcounter = 0;

	always@(hcounter or vcounter) begin
        // black everywhere
        red   <= 3'b0;
        green <= 3'b0;
        blue  <= 3'b0;

        // sync
        hsync <= 1'b0;
        vsync <= 1'b0;
        blank <= 1'b0;

        // sync pulses
        if(hcounter > 839 && hcounter < 967)
           hsync <= 1'b1;
        if(vcounter > 600 && vcounter < 604)
           vsync <= 1'b1;
        if(hcounter > 799 || vcounter > 599)
           blank <= 1'b1;

        // draw a blue border
        if(vcounter < 600) begin
            if(hcounter < 800) begin
                if(vcounter < 10 || vcounter > 589 || hcounter < 10 || hcounter > 789) begin
                   red  <= 3'b000;
                   blue <= 3'b111;
                   green <=3'b000;
                end
            end
        end
    end

    // increment counters and wrap them
    always@(posedge clk) begin
        if(hcounter == 1055) begin
            hcounter <= 0;
            if(vcounter == 627)
                vcounter <= 0;
            else
                vcounter <= vcounter + 1;
            end
        else
            hcounter <= hcounter + 1;
    end
endmodule
