// This module is basically the same as the amplitude modulator in:
// https://github.com/gundy/tiny-synth

module am(
    input clk,
    input [7:0] envelope,
    input signed [11:0] waveIn,
    output wire signed [11:0] waveOut
);

    wire signed [7:0] envelopeSigned;
    reg signed [19:0] waveScaled;
    assign envelopeSigned = {1'b0, envelope[7:0]};

    always_ff @ (posedge clk) begin
        waveScaled <= (waveIn * envelopeSigned);
    end

    assign waveOut = waveScaled[19:8];

endmodule