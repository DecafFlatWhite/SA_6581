module acc(
    input clk, rst,
    input [15:0] freq,
    input [11:0] pw,
    //input [7:0] control,
    //input [11:0] syncIn,
    //output [11:0] syncOut,
    output reg [23:0] waveOut 
);

    // https://trondal.com/c64sid/yannes.html
    // Clock at 1 MHz

    reg state = 1'b0;
    // state 0: Low state, output is 0.
    // state 1: high state, output is the accumulator.
    reg flag = 1'd0;
    reg [31:0] cycleCount = 32'd0;
    reg [23:0] accumulator;
    // 48-bit is probably not nessesary but I dont want to deal with overflow...
    wire [47:0] zeroOutput;
    wire [31:0] eqnFreq;
    // Count how much cycle it needs to wait before the actual output.
    // Since the 16-bit freq is not the actual frequency, the value needs to be
    // multipled by 0.0596. 
    assign zeroOutput = (10000 * (12'd4095 - pw) * 20'd1000000) / (12'd4095 * freq * 596);
    // For the equvalent frequency we dont need to deal with real world 
    // frequency, so this value is not multiplied
    assign eqnFreq = (freq * 12'd4095) / pw;

    always_ff @(posedge clk or negedge rst) begin

        if (!rst) begin
            state <= 1'b0;
            accumulator <= 24'd0;
            cycleCount <= 32'd0;  
            flag <= 1'b0; 
        end

        case (state)
            1'b0: begin
                if (cycleCount < zeroOutput) begin
                    state <= 1'b0;
                    cycleCount <= cycleCount + 1;
                // This if statement is probably not nessesary
                end else if (cycleCount == zeroOutput) begin
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
                // Now a whole period passed and reset the state.
                end else if (accumulator[23] == 1'b0 && flag == 1'b1) begin
                    flag <= 1'b0;
                    cycleCount <= 32'd0;
                    state <= 1'b0;
                end
            end
            default: ;
        endcase
    end

    always_comb begin
        case (state)
            1'b0: waveOut = 24'd0;
            1'b1: waveOut = accumulator;
            default: ;
        endcase
    end

endmodule