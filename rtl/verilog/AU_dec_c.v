//==============================================================================
// AU_dec_c.v
//
// Decrementer using parallel-prefix propagate-lookahead logic with:
// carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_dec_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // input data
    input              ci,  // carry-in
    output [WIDTH-1:0] z,   // decrement
    output             co   // carry-out
);


    // Structural model
    wire [WIDTH:0] ai;
    wire [WIDTH:0] po;


    // Invert a for decrement
    assign ai = {~a, ci};

    // Calculate prefix output propagate signal
    AU_prefix_and #(
        .WIDTH(WIDTH + 1),
        .ARCH (ARCH)
    ) u_AU_prefix_and (
        .pi(ai),
        .po(po)
    );

    // Calculate result and carry-out bits
    assign z = a ^ po[WIDTH - 1 : 0];
    assign co = po[WIDTH];


endmodule
