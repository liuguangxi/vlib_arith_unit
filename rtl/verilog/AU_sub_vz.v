//==============================================================================
// AU_sub_vz.v
//
// Binary subtractor using parallel-prefix carry-lookahead logic with:
//   - carry-in (ci), subtracted
//   - 2's complement overflow flag (v)
//   - zero flag (z), only valid for ci = 0
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_sub_vz #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // minuend
    input  [WIDTH-1:0] b,   // subtrahend
    input              ci,  // carry-in
    output [WIDTH-1:0] s,   // difference
    output             v,   // overflow flag
    output             z    // zero flag
);


    // Structural model
    generate
        wire [WIDTH-1:0] bi;
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pt;
        wire [WIDTH-1:0] go;
        wire [WIDTH-1:0] po;

        // Invert b for subtraction
        assign bi = ~b;

        // Calculate prefix input generate/propagate signal (0)
        assign gi[0] = (a[0] & bi[0]) | (a[0] & (~ci)) | (bi[0] & (~ci));
        assign pi[0] = a[0] ^ bi[0];

        // Calculate adder propagate signal (0) (pt = a xor b)
        assign pt[0] = pi[0];

        if (WIDTH >= 2) begin : g_gi_pi_pt
            // Calculate prefix input generate/propagate signals (1 to WIDTH-1)
            assign gi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] & bi[WIDTH - 1 : 1];
            assign pi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] ^ bi[WIDTH - 1 : 1];

            // Calculate adder propagate signals (1 to WIDTH-1) (pt = a xor b)
            assign pt[WIDTH - 1 : 1] = pi[WIDTH - 1 : 1];
        end

        if (WIDTH == 1) begin : g_s_1
            // Calculate sum bit, overflow bit, and zero flag
            assign s = pt ^ (~ci);
            assign v = gi ^ (~ci);
            assign z = pi;
        end else begin : g_s_2
            // Calculate prefix output generate/propagate signals
            AU_prefix_and_or #(
                .WIDTH(WIDTH),
                .ARCH (ARCH)
            ) u_AU_prefix_and_or (
                .gi(gi),
                .pi(pi),
                .go(go),
                .po(po)
            );

            // Calculate sum bits, overflow bit, and zero flag
            assign s = pt ^ {go[WIDTH - 2 : 0], ~ci};
            assign v = go[WIDTH - 1] ^ go[WIDTH - 2];
            assign z = po[WIDTH - 1];
        end
    endgenerate


endmodule
