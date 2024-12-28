
module am(
    input clk,
    input [7:0] envelope,
    input [11:0] waveIn,
    output reg [11:0] waveOut
);

    reg [19:0] waveScaled;

    always_ff @ (posedge clk) begin
        waveScaled = (waveIn * envelope);
        // The value need to be divided by 256 to normalize the envelope, which
        // is the same as right shift by 8 bits. 
        waveOut <= (waveScaled >> 8); 
    end

endmodule


