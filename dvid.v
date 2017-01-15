`default_nettype none
module dvid (
    input wire clk,
    input wire hsync,
    input wire vsync,
    input wire blank,
    input wire [2:0] red,
    input wire [2:0] green,
    input wire [2:0] blue,

    output wire [3:0] hdmi_p,
    output wire [3:0] hdmi_n
    );

    wire [1:0] ctls [2:0];
    wire [2:0] colours [2:0];

    reg [9:0] symbols [3:0];

    assign ctls[0] = { vsync, hsync };
    assign colours[0] = red;
    assign colours[1] = green;
    assign colours[2] = blue;

    initial begin
        // clock
        symbols[3] = 10'b0000011111;
    end

    integer i;
	always@(posedge clk) begin
        for(i=0; i<=2; i=i+1) begin
            if(blank == 1'b1) begin
                case(ctls[i])
                    // think these might be back to front
                    2'b00: symbols[i] <= 10'b1101010100;
                    2'b01: symbols[i] <= 10'b0010101011;
                    2'b10: symbols[i] <= 10'b0101010100;
                    default: symbols[i] <= 10'b1010101011;
                endcase
            end else begin
                case(colours[i])
                    3'b000: symbols[i] <= 10'b0111110000;
                    3'b001: symbols[i] <= 10'b0001001111;
                    3'b010: symbols[i] <= 10'b0111001100;
                    3'b011: symbols[i] <= 10'b0010001111;
                    3'b100: symbols[i] <= 10'b0000101111;
                    3'b101: symbols[i] <= 10'b1000111001;
                    3'b110: symbols[i] <= 10'b1000011011;
                    default: symbols[i] <= 10'b1011110000;
                endcase
            end
        end
    end

    /*
    todo:
    high speed clock
    ddr, lvds
    clocking symbol data out to lvds lines
    */

endmodule

