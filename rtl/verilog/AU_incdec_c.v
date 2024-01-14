//==============================================================================
// AU_incdec_c.v
//
// Incrementer-decrementer using parallel-prefix propagate-lookahead logic with:
// carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_incdec_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,        // input data
    input              ci,       // carry-in
    input              inc_dec,  // control, 0:increment, 1:decrement
    output [WIDTH-1:0] z,        // increment or decrement
    output             co        // carry-out
);


    // Structural model
    wire [WIDTH:0] ai;
    wire [WIDTH:0] po;


    // Invert a for increment/decrement
    assign ai = {a ^ {WIDTH{inc_dec}}, ci};

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
