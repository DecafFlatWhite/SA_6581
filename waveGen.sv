module waveGen(
    input clk, rst,
    input [7:0] control,
    input [11:0] pw,
    input [11:0] noiseIn,
    input [23:0] waveIn,

    output reg [11:0] waveOut 
);
    reg [11:0] sawtooth;
    reg [11:0] pulse;
    reg [11:0] noise;
    reg [11:0] triangle;


    always_comb begin
        triangle = {waveIn[22:12] ^ waveIn[23], 1'b0};
        pulse = waveIn[23:12] < pw ? 12'd1 : 12'd0;
        sawtooth = waveIn[23:12];
        noise = noiseIn;
    end

    always_comb begin
        case(control[7:4])
            4'b1000: waveOut = noise;
            4'b0100: waveOut = pulse;
            4'b0010: waveOut = sawtooth;
            4'b0001: waveOut = triangle;
            default: waveOut = 12'd0;
        endcase
    end
endmodule