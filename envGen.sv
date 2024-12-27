module envGen(
    input clk, rst,
    input [7:0] control,
    // Combine the two regs as the input: {reg#05, reg#06}
    // Consult the datasheet for details
    input [15:0] adsr,

    output reg [7:0] volOut 
);  
    // How many clock cycles it'll take to finish the whole attack cycle?

    // We can just use one LUT to get numbers of cycles needed for all of the 
    // state since the decay/release rate is just three times of the attack rate
    const bit [22:0] attackTable [0:15] = '{
        23'd2000,    23'd8000,    23'd16000,   23'd24000,
        23'd38000,   23'd56000,   23'd68000,   23'd80000,
        23'd100000,  23'd250000,  23'd500000,  23'd800000,
        23'd1000000, 23'd3000000, 23'd5000000, 23'd8000000
    };
    // Hard-coded attack rate since the output will always be incremented from 0
    // to 255 during the attack cycle
    parameter attackRate = 8'd255;

    reg [1:0] state;
    reg [7:0] decayRate;
    reg [28:0] counter;
    reg [27:0] cycle;

    always_comb begin
        case (state) 
            2'b00: begin
                cycle = attackTable[adsr[15:12]];
            end
            2'b01: begin
                // During the decay cycle the output will go from 255 to the 
                // sustain level
                decayRate = 8'd255 - (8 * adsr[7:4]);
                cycle = 3 * attackTable[adsr[11:8]];
            end
            2'b10: begin
                
            end
            2'b11: begin
                // During the release cycle the output will go from sustain 
                // level to 0
                decayRate = 8 * adsr[3:0];
                cycle = 3 * attackTable[adsr[3:0]];
            end
            default: ;
        endcase
    end

    always_ff @ (posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 1'd0;
            volOut <= 7'd0;
            counter <= 28'd0;
        end else begin
            case (state)
                2'b00: begin
                    if (control[0]) begin
                        counter <= counter + attackRate;
                        if (volOut == 8'b11111111) begin
                            state <= 2'b01;
                            counter <= 28'd0;
                        // Counter is equivalent to the numerator of a fraction
                        // with cycle as the denom.
                        // This is to address the problem that cycle / 255 is 
                        // not an integer
                        end else if (counter >= cycle) begin
                            counter <= counter - cycle;
                            volOut <= volOut + 1'b1;
                        end
                    end
                end
                2'b01: begin
                    if (control[0]) begin
                        // we can still do this cause we already reset the 
                        // counter before we get into this state
                        counter <= counter + decayRate;
                        if (volOut == (8 * adsr[3:0])) begin
                            state <= 2'b10;
                            counter <= 28'd0;
                        end else if (counter >= cycle) begin
                            counter <= counter - cycle;
                            volOut <= volOut - 1'b1;
                        end
                    end
                end
                2'b10: begin
                    // We are literally doing nothing during the sustain cycle
                    // The only thing we need to be aware of is if the GATE bit
                    // is flipped, if that is true we get into the next state 
                    if (~control[0]) begin
                        state <= 2'b11;
                        counter <= 28'd0;
                    end
                end
                2'b11: begin
                    if (~control[0]) begin
                        counter <= counter + decayRate;
                        if (volOut == 8'b00000000) begin
                            state <= 2'b00;
                            counter <= 28'd0;
                        end else if (counter >= cycle) begin
                            counter <= counter - cycle;
                            volOut <= volOut - 1'b1;
                        end
                    end
                end
                default: ;
            endcase
        end
    end

endmodule