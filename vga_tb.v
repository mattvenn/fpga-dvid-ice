module test;

  reg clk = 0;
  wire hsync;
  wire vsync;

  /* Make a reset that pulses once. */
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0, test);
     $dumpoff;
     # 2000000;
     $dumpon;
     # 2000000;
     $finish;
  end

  vga vga_test(.clk(clk), .hsync(hsync), .vsync(vsync));

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

endmodule // test
