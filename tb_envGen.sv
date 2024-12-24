module envtb();
    reg clk;
    reg rst;
    reg [7:0] control;
    reg [15:0] adsr;

    reg [7:0] volLast;
    wire [7:0] volOut;

    envGen dut(clk, rst, control, adsr, volOut);

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

        control = 8'b00000001;
        adsr = 16'b1111_1111_1000_1111;
    end

    always @(posedge clk) begin
        if(dut.state == 2'b10) begin
            #100;
            control =  8'b00000000;
        end
    end
    
endmodule