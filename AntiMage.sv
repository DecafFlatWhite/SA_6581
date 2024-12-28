
module am(
    input clk,
    input [7:0] envelope,
    input signed [11:0] waveIn,
    output reg [11:0] waveOut
);
    reg signed [8:0] signedEnvelope;
    reg signed [11:0] signedWaveIn;
    reg signed [19:0] waveScaled;
    
    always_ff @ (posedge clk) begin
        signedEnvelope = {1'b0, envelope};
        signedWaveIn = waveIn - 12'd2048;
        waveScaled = (signedWaveIn * signedEnvelope);
        // The value need to be divided by 256 to normalize the envelope, which
        // is the same as right shift by 8 bits. 
        waveOut <= ((waveScaled >> 8) + 12'd2048); 
    end

endmodule


