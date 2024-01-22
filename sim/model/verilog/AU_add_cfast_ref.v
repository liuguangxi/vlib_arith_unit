//==============================================================================
// AU_add_cfast_ref.v
//
// Behavioral model of AU_add_cfast.
// Binary adder using parallel-prefix carry-lookahead logic with:
// fast carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_add_cfast_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // augend
    input  [WIDTH-1:0] b,   // addend
    input              ci,  // carry-in
    output [WIDTH-1:0] s,   // sum
    output             co   // carry-out
);


    // Behavioral model
    wire [WIDTH:0] temp;

    assign temp = a + b + ci;
    assign s = temp[WIDTH - 1 : 0];
    assign co = temp[WIDTH];


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
