/*******************************************************************************
Test plan:
1. Test each wave form
2. Test if the DC gain(?) is right after the AM
*******************************************************************************/

module voicetb();
    reg clk, rst;
    reg [7:0] control;
    reg [11:0] pw;
    reg [15:0] adsr;
    reg [15:0] freq;
    wire [11:0] dataOut;

    voice dut(clk, rst, control, pw, adsr, freq, dataOut);

    initial begin
        clk = 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #33;
        rst = 1'b0; 
        #10 
        rst = 1'b1;

        control = 8'b00010001;
        adsr = 16'b0011_0011_0111_0011;
        freq = 16'd4389; // C4
        pw = 12'b0111_1111_1111;
    end

    always @(posedge clk) begin
        if(dut.envGen_v.state == 2'b10) begin
            #500;
            control = 8'b00010000;
        end
    end
endmodule