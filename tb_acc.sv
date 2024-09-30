module acctb();

    reg clk, rst, flag;
    reg [11:0] freq;
    reg [31:0] timer;

    wire [23:0] waveOut;

    acc dut(clk, rst, freq, waveOut);

    initial begin
        clk = 1'b1;
        forever #2 clk = ~clk;
    end
    
    initial begin
        if (flag == 0 && clk == 1'b1) begin
            timer = timer + 1;
        end
    end

    initial begin
        #3;
        rst = 1'b0; 
        #10 rst = 1'b1;

        flag = 0;
        timer = 32'd0;  // Initialize timer
        freq = 12'd114;
        
        if (waveOut == 24'b111111111111111111111111) begin
            flag = 1;
            $display("%d cycle has passed before overflow", timer);
            #10;
            $stop;
        end
    end

endmodule

