# DVI-D in Verilog use IceStorm open tools

Minimal DVI-D output based on Mike Field's work (see credits below).

# Current status

* differential lines are working
* can set different clocks speeds for testing (need lower clock for my scope)
* can't get generate loop to work to create the differential DDR blocks

## Scope pics

Following pics are with the x5 clock for DVI output set to 50MHz (target is
200MHz). Top 4 traces are Clock, R, G, B. Bottom 5 traces are 12MHz clock, DVI
clock (50MHz), VGA clock (10MHz), blank, vsync, hsync.

![hsync and vsync zoomed out](docs/TEK00001.PNG)

![hsync zoomed in](docs/TEK00002.PNG)

I can just about read the lines, it would be good to see the logic levels
recovered by the monitor when adding the negative sides of the signals.

## GTKwave traces

I think these show that the verilog is correct, at least it is what I expect.

![blanking](docs/blank.png)

![hsync](docs/hsync.png)

![rgb](docs/rgb.png)

# Electrical connections

I'm not even sure if I can do this on a breadboard, here's the [current messy
status](https://goo.gl/photos/bQrL8b5GGyBhnb3S8)

There are no external components, the differential lines are going straight to
the DVI-D breakout. If I can get something looking promising, the plan is to
make a PMOD DVI-D breakout.

# Resources / Credits

lots of thanks to Mike Field of [hamsterworks](http://hamsterworks.co.nz) for
great resources on dvi and vga. Here are some resources I've used in developing
this project.

* http://hamsterworks.co.nz/mediawiki/index.php/VGA_timings
* http://hamsterworks.co.nz/mediawiki/index.php/FPGA_VGA
* https://github.com/jeelabs/fpga/blob/master/quartus/vga1024/top.vga
