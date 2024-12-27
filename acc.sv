module acc(
    input clk, rst,
    input [15:0] freq,
    input [11:0] pw,
    //input [11:0] syncIn,
    //output [11:0] syncOut,
    output reg [23:0] waveOut,
    output reg [11:0] noiseOut
);

    // https://trondal.com/c64sid/yannes.html
    // Clock at 1 MHz

    // state 0: Low state, output is 0.
    // state 1: high state, output is the accumulator.
    reg state;
    reg flag;
    // For noise generation.
    reg [22:0] random;
    reg [31:0] cycleCount;
    // 48-bit is probably not nessesary but I dont want to deal with overflow...
    reg [23:0] accumulator;
    reg [47:0] zeroOutput;
    reg [31:0] eqnFreq;
    

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 1'b0;
            // Assign a random non-zero value
            random <= 23'd4194300;
            accumulator <= 24'd0;
            cycleCount <= 32'd0;  
            flag <= 1'b0; 
        end else begin
            // Count how much cycle it needs to wait before the actual output.
            // Since the 16-bit freq is not the actual frequency, the value needs to be
            // multipled by 0.0596. 
            // The value is multiplied by 10000 to prevent any floating point shit.
            zeroOutput <= (10000 * (12'd4095 - pw) * 20'd1000000) / (12'd4095 * freq * 596);
            // For the equvalent frequency we dont need to deal with real world 
            // frequency, so this value is not multiplied
            eqnFreq <= (freq * 12'd4095) / pw;
            // "The shift register was clocked by one of the intermediate bits
            // of the accumulator to keep the frequency content of the noise
            // waveform relatively the same as the pitched waveforms."
            if (accumulator[12]) begin
                // TBH I don't have an idea of how to implement this
                // pseudo-random shit so I just copied the code I got from GPT
                // LOL
                random <= {random[21:0], random[22] ^ random[17]};
            end
            case (state)
                1'b0: begin
                    if (cycleCount < zeroOutput) begin
                        state <= 1'b0;
                        cycleCount <= cycleCount + 1;
                    // This if statement is probably not nessesary
                    end else begin
                        state <= 1'b1;
                    end
                end
                1'b1: begin 
                    accumulator <= accumulator + eqnFreq;
                    // Is the MSB flipped?
                    // If the MSB flips that means an overflow is about to happen.
                    if (accumulator[23] == 1'b1) begin
                        flag <= 1'b1;
                    // If the MSB flipped and the flag is pulled, that means an 
                    // overflow happened.
                    // Now a whole period have passed and reset the state.
                    end else if (accumulator[23] == 1'b0 && flag == 1'b1) begin
                        flag <= 1'b0;
                        cycleCount <= 32'd0;
                        state <= 1'b0;
                    end 
                end
                default: ;
            endcase
        end
    end

    always_comb begin
        case (state)
            1'b0: begin 
                waveOut = 24'd0;
                noiseOut = 12'd0;

            end
            1'b1: begin
                waveOut = accumulator;
                noiseOut = random[22:11];
            end
            default: ;
        endcase

    end

endmodule