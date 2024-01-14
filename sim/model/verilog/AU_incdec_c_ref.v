//==============================================================================
// AU_incdec_c_ref.v
//
// Behavioral model of AU_incdec_c.
// Incrementer-decrementer using parallel-prefix propagate-lookahead logic with:
// carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_incdec_c_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,        // input data
    input              ci,       // carry-in
    input              inc_dec,  // control, 0:increment, 1:decrement
    output [WIDTH-1:0] z,        // increment or decrement
    output             co        // carry-out
);


    // Behavioral model
    assign {co, z} = (inc_dec == 1'b0) ? {1'b0, a} + ci : {1'b0, a} - ci;


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
