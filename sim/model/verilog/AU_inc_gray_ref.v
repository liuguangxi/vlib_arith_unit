//==============================================================================
// AU_inc_gray_ref.v
//
// Behavioral model of AU_inc_gray.
// Incrementer for Gray numbers using parallel-prefix propagate-lookahead logic.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_inc_gray_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input      [WIDTH-1:0] a,  // Gray coded input data
    output reg [WIDTH-1:0] z   // Gray coded output data
);


    // Behavioral model
    reg [WIDTH:0] bv;
    wire [WIDTH:0] zv;
    integer i;

    always @(*) begin
        bv[WIDTH] = 1'b0;
        for (i = WIDTH - 1; i >= 0; i = i - 1) begin
            bv[i] = bv[i + 1] ^ a[i];
        end
    end

    assign zv[WIDTH - 1 : 0] = bv[WIDTH - 1 : 0] + 1'b1;
    assign zv[WIDTH] = 1'b0;

    always @(*) begin
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin
            z[i] = zv[i + 1] ^ zv[i];
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
