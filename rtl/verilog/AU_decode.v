//==============================================================================
// AU_decode.v
//
// Decodes a binary number into a vector with a '1' at the according position.
// Example: a = "101" -> z = "00100000".
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_decode #(
    parameter integer WIDTH = 3,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [   WIDTH-1:0] a,  // input data
    output [2**WIDTH-1:0] z   // decoded output data
);


    // Structural model
    generate
        if (ARCH == 0) begin : g_sh
            assign z = 1'b1 << a;
        end

        if (ARCH == 1) begin : g_dec
            genvar i;

            for (i = 0; i <= 2 ** WIDTH - 1; i = i + 1) begin : g_bits
                assign z[i] = (a == $unsigned(i)) ? 1'b1 : 1'b0;
            end
        end

        if (ARCH == 2) begin : g_mux
            genvar i;
            wire [2**WIDTH-1:0] dv[0:WIDTH];

            assign dv[0] = 1'b1;
            for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_levels
                assign dv[i + 1] = (a[i] == 1'b1) ? (dv[i] << (2 ** i)) : dv[i];
            end
            assign z = dv[WIDTH];
        end
    endgenerate


endmodule
