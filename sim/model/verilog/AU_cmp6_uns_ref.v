//==============================================================================
// AU_cmp6_uns_ref.v
//
// Behavioral model of AU_cmp6_uns.
// Compares two unsigned numbers and produces the following six
// output conditions:
//   1. Less-than (LT)
//   2. Greater-than (GT)
//   3. Equal (EQ)
//   4. Less-than-or-equal (LE)
//   5. Greater-than-or-equal (GE)
//   6. Not equal (NE)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_cmp6_uns_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // input data
    input  [WIDTH-1:0] b,   // input data
    output             lt,  // less-than output condition
    output             gt,  // greater-than output condition
    output             eq,  // equal output condition
    output             le,  // less-than-or-equal output condition
    output             ge,  // greater-than-or-equal output condition
    output             ne   // not equal output condition
);


    // Behavioral model
    assign lt = (a < b) ? 1'b1 : 1'b0;
    assign gt = (a > b) ? 1'b1 : 1'b0;
    assign eq = (a == b) ? 1'b1 : 1'b0;
    assign le = (a <= b) ? 1'b1 : 1'b0;
    assign ge = (a >= b) ? 1'b1 : 1'b0;
    assign ne = (a != b) ? 1'b1 : 1'b0;


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
