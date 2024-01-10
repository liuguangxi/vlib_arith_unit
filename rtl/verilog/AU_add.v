//==============================================================================
// AU_add.v
//
// Binary adder using parallel-prefix carry-lookahead logic.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_add #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // augend
    input  [WIDTH-1:0] b,  // addend
    output [WIDTH-1:0] s   // sum
);


    // Structural model
    generate
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pt;
        wire [WIDTH-1:0] go;

        // Calculate prefix input generate/propagate signals
        assign gi = a & b;
        assign pi = a | b;

        // Calculate adder propagate signals (pt = a xor b)
        assign pt = (~gi) & pi;

        if (WIDTH == 1) begin : g_s_1
            // Calculate sum bit
            assign s = pt;
        end else begin : g_s_2
            // Calculate prefix output generate/propagate signals
            AU_prefix_and_or #(
                .WIDTH(WIDTH),
                .ARCH (ARCH)
            ) u_AU_prefix_and_or (
                .gi(gi),
                .pi(pi),
                .go(go),
                .po()
            );

            // Calculate sum bits
            assign s = pt ^ {go[WIDTH - 2 : 0], 1'b0};
        end
    endgenerate


endmodule
