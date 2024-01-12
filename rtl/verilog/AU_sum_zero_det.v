//==============================================================================
// AU_sum_zero_det.v
//
// Detects an all-zeros sum of an addition in constant time, i.e. without
// waiting for the slow addition result (or without performing the addition).
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_sum_zero_det #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // input data
    input  [WIDTH-1:0] b,   // input data
    input              ci,  // carry-in
    output             z    // all-zeros sum flag
);


    // Structural model
    generate
        wire [WIDTH-1:0] zt;

        // Zero flag for individual bits
        assign zt[0] = ~(a[0] ^ b[0] ^ ci);

        if (WIDTH >= 2) begin : g_zt
            assign zt[WIDTH-1 : 1] = ~(a[WIDTH-1 : 1] ^ b[WIDTH-1 : 1] ^ (a[WIDTH-2 : 0] | b[WIDTH-2 : 0]));
        end

        // AND all bit zero flags
        assign z = &zt;
    endgenerate


endmodule
