//==============================================================================
// AU_cmp_eq.v
//
// Equality comparison of two numbers.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_cmp_eq #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // input data
    input  [WIDTH-1:0] b,  // input data
    output [WIDTH-1:0] eq  // equal output condition
);


    // Structural model
    wire [WIDTH-1:0] eqt;

    assign eqt = ~(a ^ b);
    assign eq = &eqt;


endmodule
