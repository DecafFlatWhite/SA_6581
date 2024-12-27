module voice(
    input clk, rst,
    input [7:0] control,
    input [11:0] pw,
    input [15:0] adsr,
    input [15:0] freq,

    output wire [11:0] voiceOut
);

    wire [23:0] accOut;
    wire [11:0] noiseOut, waveOut;
    wire [7:0] envOut;

    acc acc_v (clk, rst, freq, pw, accOut, noiseOut);
    waveGen waveGen_v (clk, rst, control, pw, noiseOut, accOut, waveOut);
    envGen envGen_v (clk, rst, control, adsr, envOut);
    am am_v (clk, envOut, waveOut, voiceOut);
    
endmodule