//==============================================================================
// AU_full_adder.v
//
// Full adder. Should force the compiler to use a full-adder cell instead of
// simple logic gates.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_full_adder (
    // Data interface
    input  a,   // augend
    input  b,   // addend
    input  ci,  // carry-in
    output s,   // sum
    output co   // carry-out
);


    // Structural model
    assign s = a ^ b ^ ci;
    assign co = (a & b) | (b & ci) | (a & ci);


endmodule
