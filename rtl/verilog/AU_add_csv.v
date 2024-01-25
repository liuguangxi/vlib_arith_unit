//==============================================================================
// AU_add_csv.v
//
// Three-operand carry-save adder using full-adders.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_add_csv #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [WIDTH-1:0] a1,  // input data
    input  [WIDTH-1:0] a2,  // input data
    input  [WIDTH-1:0] a3,  // input data
    output [WIDTH-1:0] s,   // sum
    output [WIDTH-1:0] c    // carry
);


    // Structural model
    generate
        genvar i;
        wire [WIDTH-1:0] ct;

        // Carry-save addition using full-adders
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_bits
            AU_full_adder u_AU_full_adder (
                .a (a1[i]),
                .b (a2[i]),
                .ci(a3[i]),
                .s (s[i]),
                .co(c[i])
            );
        end
    endgenerate


endmodule
