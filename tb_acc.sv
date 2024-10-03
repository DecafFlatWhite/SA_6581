module acctb();

    reg clk;
    reg rst;
    reg [15:0] freq;
    reg [11:0] pw;

    wire [23:0] waveOut;

    acc dut(clk, rst, freq, pw, waveOut);

    initial begin
        clk = 1'b1;
        forever #2 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #3;
        rst = 1'b0; 
        #10 rst = 1'b1;

        timer = 32'd0; 
        freq = 16'd4389; // C4
        pw = 12'd2047;  // 50 % duty cycle 
    end

endmodule
