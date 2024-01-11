//==============================================================================
// AU_sub.v
//
// Binary subtractor using parallel-prefix carry-lookahead logic.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_sub #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // minuend
    input  [WIDTH-1:0] b,  // subtrahend
    output [WIDTH-1:0] s   // difference
);


    // Structural model
    generate
        wire [WIDTH-1:0] bi;
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pt;
        wire [WIDTH-1:0] go;

        // Invert b for subtraction
        assign bi = ~b;

        // Calculate prefix input generate/propagate signal (0)
        assign gi[0] = a[0] | bi[0];
        assign pi[0] = 1'b0;

        // Calculate adder propagate signal (0) (pt = a xor b)
        assign pt[0] = a[0] ^ bi[0];

        if (WIDTH >= 2) begin : g_gi_pi_pt
            // Calculate prefix input generate/propagate signals (1 to WIDTH-1)
            assign gi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] & bi[WIDTH - 1 : 1];
            assign pi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] | bi[WIDTH - 1 : 1];

            // Calculate adder propagate signals (1 to WIDTH-1)
            assign pt[WIDTH - 1 : 1] = (~gi[WIDTH - 1 : 1]) & pi[WIDTH - 1 : 1];
        end

        if (WIDTH == 1) begin : g_s_1
            // Calculate sum bit
            assign s = ~pt;
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
            assign s = pt ^ {go[WIDTH - 2 : 0], 1'b1};
        end
    endgenerate


endmodule
