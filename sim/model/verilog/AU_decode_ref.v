//==============================================================================
// AU_decode_ref.v
//
// Behavioral model of AU_decode.
// Decodes a binary number into a vector with a '1' at the according position.
// Example: a = "101" -> z = "00100000".
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_decode_ref #(
    parameter integer WIDTH = 3,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [   WIDTH-1:0] a,  // input data
    output [2**WIDTH-1:0] z   // decoded output data
);


    // Behavioral model
    reg [2**WIDTH-1:0] zv;

    always @(*) begin
        zv = 'b0;
        zv[a] = 1'b1;
    end

    assign z = zv;


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
