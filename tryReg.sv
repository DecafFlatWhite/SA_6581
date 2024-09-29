module regFile (
    input clk,
    input w_en,
    input [4:0] w_addr,
    input [7:0] w_data,

    input [7:0] potx,
    input [7:0] poty,
    input [7:0] osc3,
    input [7:0] env3,

    output reg [7:0] freqLo1,
    output reg [7:0] freqHi1,
    output reg [7:0] pwLo1,
    output reg [7:0] pwHi1,
    output reg [7:0] control1,
    output reg [7:0] a_d1,
    output reg [7:0] s_r1,

    output reg [7:0] freqLo2,
    output reg [7:0] freqHi2,
    output reg [7:0] pwLo2,
    output reg [7:0] pwHi2,
    output reg [7:0] control2,
    output reg [7:0] a_d2,
    output reg [7:0] s_r2,

    output reg [7:0] freqLo3,
    output reg [7:0] freqHi3,
    output reg [7:0] pwLo3,
    output reg [7:0] pwHi3,
    output reg [7:0] control3,
    output reg [7:0] a_d3,
    output reg [7:0] s_r3,

    output reg [7:0] fcLo,
    output reg [7:0] fcHi,
    output reg [7:0] Res_Flit,
    output reg [7:0] Mode_Vol
    );

    reg [7:0] registers[7:0];

    assign registers[0] = freqLo1;
    assign registers[1] = freqHi1;
    assign registers[2] = pwLo1;
    assign registers[3] = pwHi1;
    assign registers[4] = control1;
    assign registers[5] = a_d1;
    assign registers[6] = s_r1;

    assign registers[7] = freqLo2;
    assign registers[8] = freqHi2;
    assign registers[9] = pwLo2;
    assign registers[10] = pwHi2;
    assign registers[11] = control2;
    assign registers[12] = a_d2;
    assign registers[13] = s_r2;

    assign registers[14] = freqLo3;
    assign registers[15] = freqHi3;
    assign registers[16] = pwLo3;
    assign registers[17] = pwHi3;
    assign registers[18] = control3;
    assign registers[19] = a_d3;
    assign registers[20] = s_r3;

    assign registers[21] = fcLo;
    assign registers[22] = fcHi;
    assign registers[23] = Res_Flit;
    assign registers[24] = Mode_Vol;

    always_ff @(posedge clk) begin
        if (w_en) begin
            case(w_addr)
                5'd25: registers[25] <= potx;
                5'd26: registers[26] <= poty;
                5'd27: registers[27] <= osc3;
                5'd28: registers[28] <= env3;
                default;
            endcase
        end
    end



endmodule