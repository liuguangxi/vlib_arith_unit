//==============================================================================
// AU_bin2gray_ref.v
//
// Behavioral model of AU_bin2gray.
// Converts a number from binary to Gray representation.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_bin2gray_ref #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input      [WIDTH-1:0] b,  // binary input data
    output reg [WIDTH-1:0] g   // Gray output data
);


    // Behavioral model
    reg [WIDTH:0] bv;
    integer i;

    always @(*) begin
        bv = {1'b0, b};
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin
            g[i] = bv[i + 1] ^ bv[i];
        end
    end


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
