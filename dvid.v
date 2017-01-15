`default_nettype none
module dvid (
    input wire clkx5,
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
    reg [9:0] high_speed_sr [3:0];
    reg [4:0] high_speed_latch = 5'b00001;

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

    // from hamster's work, this is missing the output buffer and the 2bit output_bits for each channel
    always@(posedge clkx5) begin
        for(i = 0; i <= 3; i = i + 1) begin
            if(high_speed_latch[0] == 1'b1)
                high_speed_sr[i] <= symbols[i];
            else
                high_speed_sr[i] <= { 2'b00, high_speed_sr[i][9:2] };
        end
        high_speed_latch <= { high_speed_latch[0], high_speed_latch[4:1] };
    end

    // ddr details: http://www.latticesemi.com/view_document?document_id=47960
    // this generate doesn't work yet, defparams have issues
    /*
    genvar index;  
    generate  
    for (index=0; index < 1; index=index+1)  
      begin: gen_code_label  
        defparam differential_output_b.PIN_TYPE = 6'b010000;
        defparam differential_output_b.IO_STANDARD = "SB_LVCMOS" ;
        SB_IO differential_output_b (
        .PACKAGE_PIN(hdmi_p[index]),
        .LATCH_INPUT_VALUE (1'b1 ),
        .CLOCK_ENABLE (1'b1  ),
        .INPUT_CLK ( clkx5 ),
        .OUTPUT_CLK ( clkx5 ),
        .OUTPUT_ENABLE (1'b1 ),
        .D_OUT_0 (high_speed_sr[index][0]), // Non-inverted
        .D_OUT_1 (high_speed_sr[index][1]), // Non-inverted
        );
        // Inverting, N-side of pair
        defparam differential_output_a.PIN_TYPE = 6'b010000 ;
        defparam differential_output_a.IO_STANDARD = "SB_LVCMOS" ;
        SB_IO differential_output_a (
        .PACKAGE_PIN(hdmi_n[index]),
        .LATCH_INPUT_VALUE ( 1'b1),
        .CLOCK_ENABLE ( 1'b1),
        .INPUT_CLK ( clkx5 ),
        .OUTPUT_CLK (clkx5),
        .OUTPUT_ENABLE (1'b1 ),
        .D_OUT_0 (~high_speed_sr[index][0]), // Inverted
        .D_OUT_1 (~high_speed_sr[index][1]), // Inverted
        );
      end
    endgenerate
    */

endmodule

