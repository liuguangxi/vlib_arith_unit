//==============================================================================
// AU_add_csv_ref.v
//
// Behavioral model of AU_add_csv.
// Three-operand carry-save adder using full-adders.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_add_csv_ref #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [WIDTH-1:0] a1,  // input data
    input  [WIDTH-1:0] a2,  // input data
    input  [WIDTH-1:0] a3,  // input data
    output [WIDTH+1:0] s    // sum
);


    // Behavioral model
    assign s = a1 + a2 + a3;


    // Parameter legality check
    initial begin : parameter_check
        integer param_err_flg;

        param_err_flg = 0;

        if (WIDTH < 1) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter WIDTH (lower bound: 1)", WIDTH);
        end

        if (param_err_flg == 1) begin
            $display("%m :\n  Simulation aborted due to invalid parameter value(s)");
            $finish;
        end
    end


endmodule
