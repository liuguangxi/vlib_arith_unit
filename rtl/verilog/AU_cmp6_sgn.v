//==============================================================================
// AU_cmp6_sgn.v
//
// Compares two signed numbers and produces the following six
// output conditions:
//   1. Less-than (LT)
//   2. Greater-than (GT)
//   3. Equal (EQ)
//   4. Less-than-or-equal (LE)
//   5. Greater-than-or-equal (GE)
//   6. Not equal (NE)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_cmp6_sgn #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // input data
    input  [WIDTH-1:0] b,   // input data
    output             lt,  // less-than output condition
    output             gt,  // greater-than output condition
    output             eq,  // equal output condition
    output             le,  // less-than-or-equal output condition
    output             ge,  // greater-than-or-equal output condition
    output             ne   // not equal output condition
);


    // Structural model
    generate
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] go;
        wire [WIDTH-1:0] po;
        wire flg_v;  // signed overflow flag
        wire flg_z;  // zero flag
        wire flg_n;  // negative flag, sign

        // Calculate prefix input generate/propagate signal (0)
        assign gi[0] = a[0] | (~b[0]);
        assign pi[0] = ~(a[0] ^ b[0]);

        // Calculate prefix input generate/propagate signals
        if (WIDTH >= 2) begin : g_gi_pi
            assign gi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] & (~b[WIDTH - 1 : 1]);
            assign pi[WIDTH - 1 : 1] = ~(a[WIDTH - 1 : 1] ^ b[WIDTH - 1 : 1]);
        end

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

        // Result
        if (WIDTH == 1) begin : g_v1
            assign flg_v = ~go[WIDTH - 1];
        end else begin : g_v2
            assign flg_v = go[WIDTH - 1] ^ go[WIDTH - 2];
        end
        assign flg_z = po[WIDTH - 1];
        if (WIDTH == 1) begin : g_n1
            assign flg_n = ~pi[WIDTH - 1];
        end else begin : g_n2
            assign flg_n = pi[WIDTH - 1] ^ go[WIDTH - 2];
        end
        assign lt = flg_v ^ flg_n;
        assign gt = (~(flg_v ^ flg_n)) & (~flg_z);
        assign eq = flg_z;
        assign le = (flg_v ^ flg_n) | flg_z;
        assign ge = ~(flg_v ^ flg_n);
        assign ne = ~flg_z;
    endgenerate


endmodule
