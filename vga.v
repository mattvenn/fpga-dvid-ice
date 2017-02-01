/*
generate test pattern at 640 x 480 @ 60Hz
640x480x60  25.175  39.72   640 16  96  48  800 -   480 10  2   33  525 - 

total pixels is 800 x 525 @ 60Hz = 25.2Mhz = 39.6ns

Timings from :

* http://hamsterworks.co.nz/mediawiki/index.php/VGA_timings
* http://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml

code adapted from VHDL :

* http://hamsterworks.co.nz/mediawiki/index.php/FPGA_VGA
* http://hamsterworks.co.nz/mediawiki/index.php/Dvid_test#vga.vhd

Horizontal Timing
640     h visible
16      front
96      sync
48      back
800     whole
-       hsync

Vertical Timing

480     v visible
10      front
2       sync
33      back
525     whole
-       vsync
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
        hsync <= 1'b1;
        vsync <= 1'b1;
        blank <= 1'b0;

        // sync pulses
        if(hcounter > 655 && hcounter < 751)
           hsync <= 1'b0;
        if(vcounter > 489 && vcounter < 491)
           vsync <= 1'b0;
        if(hcounter > 639 || vcounter > 479)
           blank <= 1'b1;

        // draw a blue screen
        if(vcounter < 480) begin
            if(hcounter < 600) begin
               red  <= 3'b000;
               blue <= 3'b111;
               green <=3'b000;
            end
        end
    end

    // increment counters and wrap them
    always@(posedge clk) begin
        if(hcounter == 799) begin
            hcounter <= 0;
            if(vcounter == 524)
                vcounter <= 0;
            else
                vcounter <= vcounter + 1;
            end
        else
            hcounter <= hcounter + 1;
    end
endmodule
