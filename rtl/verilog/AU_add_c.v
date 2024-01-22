//==============================================================================
// AU_add_c.v
//
// Binary adder using parallel-prefix carry-lookahead logic with:
// carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_add_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // augend
    input  [WIDTH-1:0] b,   // addend
    input              ci,  // carry-in
    output [WIDTH-1:0] s,   // sum
    output             co   // carry-out
);


    // Structural model
    generate
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pt;
        wire [WIDTH-1:0] go;

        // Calculate prefix input generate/propagate signal (0)
        assign gi[0] = (a[0] & b[0]) | (a[0] & ci) | (b[0] & ci);
        assign pi[0] = 1'b0;

        // Calculate adder propagate signal (0) (pt = a xor b)
        assign pt[0] = a[0] ^ b[0];

        if (WIDTH >= 2) begin : g_gi_pi_pt
            // Calculate prefix input generate/propagate signals
            assign gi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] & b[WIDTH - 1 : 1];
            assign pi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] | b[WIDTH - 1 : 1];

            // Calculate adder propagate signals (pt = a xor b)
            assign pt[WIDTH - 1 : 1] = (~gi[WIDTH - 1 : 1]) & pi[WIDTH - 1 : 1];
        end

        if (WIDTH == 1) begin : g_s_1
            // Calculate sum and carry-out bits
            assign s = pt ^ ci;
            assign co = gi;
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

            // Calculate sum and carry-out bits
            assign s = pt ^ {go[WIDTH - 2 : 0], ci};
            assign co = go[WIDTH - 1];
        end
    endgenerate


endmodule
