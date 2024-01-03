//==============================================================================
// AU_gray2bin.v
//
// Converts a number from Gray to binary representation.
// Corresponds to a prefix problem in reversed bit order (compared to addition).
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_gray2bin #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] g,  // Gray input data
    output [WIDTH-1:0] b   // binary output data
);


    // Structural model
    generate
        genvar i;
        wire [WIDTH-1:0] gt;
        wire [WIDTH-1:0] bt;

        // Reverse bit order of g
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_revg
            assign gt[i] = g[WIDTH - 1 - i];
        end

        // Convert Gray to binary using prefix XOR computation
        AU_prefix_xor #(
            .WIDTH(WIDTH),
            .ARCH (ARCH)
        ) u_AU_prefix_xor (
            .pi(gt),
            .po(bt)
        );

        // Reverse bit order of b
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_revb
            assign b[i] = bt[WIDTH - 1 - i];
        end
    endgenerate


endmodule
