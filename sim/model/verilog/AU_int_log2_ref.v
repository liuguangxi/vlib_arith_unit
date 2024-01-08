//==============================================================================
// AU_int_log2_ref.v
//
// Behavioral model of AU_int_log2.
// Computes integer logarithm to base 2 (z = floor(log2(a))).
// Example: a = "00010110" -> z = "100".
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_int_log2_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [        WIDTH-1:0] a,  // input data
    output [clogb2(WIDTH)-1:0] z   // encoded output data
);


    // Calculate max(ceil(log2(x)), 1)
    function integer clogb2(input integer value);
        begin
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
            if (clogb2 < 1) clogb2 = 1;
        end
    endfunction


    // Behavioral model
    reg [clogb2(WIDTH)-1:0] zv;
    integer i;

    always @(*) begin
        zv = 'b0;
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin
            if (a[i] == 1'b1) zv = i;
        end
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

        if (param_err_flg == 1) begin
            $display("%m :\n  Simulation aborted due to invalid parameter value(s)");
            $finish;
        end
    end


endmodule
