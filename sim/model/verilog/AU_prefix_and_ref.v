//==============================================================================
// AU_prefix_and_ref.v
//
// Behavioral model of AU_prefix_and.
// Prefix structures of different depth (i.e. speed) for propagate calculation
// in different arithmetic units. Compute in M levels new propagate signal
// pairs for always larger groups of bits.
// Basic logic operation: AND for propagate signals.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_prefix_and_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] pi,  // propagate input data
    output [WIDTH-1:0] po   // propagate output data
);


    // Behavioral model
    reg [WIDTH-1:0] pv;
    integer i;

    always @(*) begin
        pv[0] = pi[0];
        for (i = 1; i <= WIDTH - 1; i = i + 1) begin
            pv[i] = pi[i] & pv[i - 1];
        end
    end

    assign po = pv;


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
