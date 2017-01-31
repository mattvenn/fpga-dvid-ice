# DVI-D in Verilog use IceStorm open tools

Minimal DVI-D output based on Mike Field's work (see credits below).

# Current status

* differential lines are working
* can set different clocks speeds for testing (need lower clock for my scope)
* RGB and clock are often distorted
* can't get generate loop to work to create the differential DDR blocks

![signals OK](docs/TEK00000.PNG)

![signals distorted](docs/TEK00001.PNG)

I think this is a clock problem to do with getting the data to the DDR blocks.

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
