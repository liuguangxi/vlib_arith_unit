//==============================================================================
// AU_sub_vz_ref.v
//
// Behavioral model of AU_sub_cz.
// Binary subtractor using parallel-prefix carry-lookahead logic with:
//   - carry-in (ci), subtracted
//   - 2's complement overflow flag (v)
//   - zero flag (z), only valid for ci = 0
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_sub_vz_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // minuend
    input  [WIDTH-1:0] b,   // subtrahend
    input              ci,  // carry-in
    output [WIDTH-1:0] s,   // difference
    output             v,   // overflow flag
    output             z    // zero flag
);


    // Behavioral model
    localparam signed [WIDTH:0] MaxSgn = {2'b00, {(WIDTH - 1) {1'b1}}};
    localparam signed [WIDTH:0] MinSgn = {2'b11, {(WIDTH - 1) {1'b0}}};
    wire signed [WIDTH:0] temp;

    assign temp = $signed({a[WIDTH - 1], a}) - $signed({b[WIDTH - 1], b}) - $signed({{WIDTH{1'b0}}, ci});
    assign s = temp[WIDTH - 1 : 0];
    assign v = (temp >= MinSgn && temp <= MaxSgn) ? 1'b0 : 1'b1;
    assign z = (temp == 'b0) ? 1'b1 : 1'b0;


    // Parameter legality check
    initial begin : parameter_check
        integer param_err_flg;

        param_err_flg = 0;

        if (WIDTH < 1) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter WIDTH (lower bound: 1)", WIDTH);
        end

        if ((ARCH < 0) || (ARCH > 2)) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter ARCH (legal range: 0 to 2)", ARCH);
        end

        if (param_err_flg == 1) begin
            $display("%m :\n  Simulation aborted due to invalid parameter value(s)");
            $finish;
        end
    end


endmodule
