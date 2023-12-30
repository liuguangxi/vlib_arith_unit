//==============================================================================
// AU_bin2gray.v
//
// Converts a number from binary to Gray representation.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_bin2gray #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [WIDTH-1:0] b,  // binary input data
    output [WIDTH-1:0] g   // Gray output data
);


    // Structural model
    assign g = b ^ (b >> 1);


endmodule
