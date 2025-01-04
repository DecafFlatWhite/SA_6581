module acctb();

    reg clk;
    reg rst;
    reg [15:0] freq;
    reg [15:0] syncFreq;
    reg [11:0] pw;
    reg [7:0] control;

    wire [15:0] syncOut;
    wire [23:0] waveOut;
    wire [11:0] noiseOut;

    acc dut(clk, rst, control, freq, pw, syncFreq, syncOut, waveOut, noiseOut);

    initial begin
        clk = 1'b1;
        forever #2 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #3;
        rst = 1'b0; 
        #10 rst = 1'b1;
        control = 8'b00001000;
        // Expect to have no output cause TEST is 1
        syncFreq = 16'd35115; // C7
        freq = 16'd4389; // C4
        pw = 12'd2047;  // 50 % duty cycle 
        #100;

        control = 8'b00000000;
        #10000;
        
        control = 8'b00000010; // Use sync frequency
        #10000;

        $finish;
        
    end

endmodule
