PROJ = vga
PIN_DEF = icestick.pcf
DEVICE = hx1k

SRC = top.v dvid.v vga.v

all: $(PROJ).rpt $(PROJ).bin

%.blif: %.v $(SRC)
	yosys -p "synth_ice40 -top top -blif $@" $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

debug-dvi:
	iverilog -o dvi vga.v dvid.v dvid_tb.v
	vvp dvi -fst
	gtkwave test.vcd gtk-dvid.gtkw

debug-vga:
	iverilog -o vga vga.v vga_tb.v
	vvp vga -fst
	gtkwave test.vcd gtk-vga.gtkw

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean
