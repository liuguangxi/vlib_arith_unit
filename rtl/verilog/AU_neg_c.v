//==============================================================================
// AU_neg_c.v
//
// Conditional 2's complementer using parallel-prefix propagate-lookahead logic.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_neg_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,    // input data
    input              neg,  // negation enable
    output [WIDTH-1:0] z     // result
);


    // Structural model
    wire [WIDTH:0] ai;
    wire [WIDTH:0] po;

    // Invert a for complement and attach carry-in
    assign ai = {a ^ {WIDTH{neg}}, neg};

    // Calculate prefix output propagate signal
    AU_prefix_and #(
        .WIDTH(WIDTH + 1),
        .ARCH (ARCH)
    ) u_AU_prefix_and (
        .pi(ai),
        .po(po)
    );

    // Calculate result bits
    assign z = ai[WIDTH : 1] ^ po[WIDTH - 1 : 0];


endmodule
