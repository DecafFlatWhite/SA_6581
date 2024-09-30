module acc(
    input clk, rst,

    input [11:0] freq,
    //input [11:0] pw,
    //input [7:0] control,

    //input [11:0] syncIn,
    //output [11:0] syncOut,

    output reg [23:0] waveOut 
);

    // https://trondal.com/c64sid/yannes.html
    // Clock at 1 MHz

    reg [23:0] accumulator;
    wire [23:0] freq_scaled;

    assign freq_scaled = (freq * 16.777216 /*Magic number LOL*/);  

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            accumulator <= 24'd0; 
        end else begin
            accumulator <= accumulator + freq_scaled;  
        end
    end

    always_comb begin
        waveOut = accumulator;
    end


endmodule