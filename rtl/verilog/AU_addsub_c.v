//==============================================================================
// AU_addsub_c.v
//
// Binary adder-subtractor using parallel-prefix carry-lookahead logic with:
// carry-in (ci) and carry-out (co)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_addsub_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,        // input data
    input  [WIDTH-1:0] b,        // input data
    input              ci,       // carry-in
    input              add_sub,  // control, 0:addition, 1:subtraction
    output [WIDTH-1:0] s,        // sum or difference
    output             co        // carry-out
);


    // Structural model
    generate
        wire [WIDTH-1:0] bi;
        wire cii;
        wire [WIDTH-1:0] gi;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pt;
        wire [WIDTH-1:0] go;

        // Invert b for subtraction
        assign bi = b ^ {WIDTH{add_sub}};
        assign cii = ci ^ add_sub;

        // Calculate prefix input generate/propagate signal (0)
        assign gi[0] = (a[0] & bi[0]) | (a[0] & cii) | (bi[0] & cii);
        assign pi[0] = 1'b0;

        // Calculate adder propagate signal (0) (pt = a xor b)
        assign pt[0] = a[0] ^ bi[0];

        if (WIDTH >= 2) begin : g_gi_pi_pt
            // Calculate prefix input generate/propagate signals (1 to WIDTH-1)
            assign gi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] & bi[WIDTH - 1 : 1];
            assign pi[WIDTH - 1 : 1] = a[WIDTH - 1 : 1] | bi[WIDTH - 1 : 1];

            // Calculate adder propagate signals (1 to WIDTH-1) (pt = a xor b)
            assign pt[WIDTH - 1 : 1] = (~gi[WIDTH - 1 : 1]) & pi[WIDTH - 1 : 1];
        end

        if (WIDTH == 1) begin : g_s_1
            // Calculate sum or difference bit and carry-out bit
            assign s = pt ^ cii;
            assign co = gi ^ add_sub;
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

            // Calculate sum or difference bits and carry-out bit
            assign s = pt ^ {go[WIDTH - 2 : 0], cii};
            assign co = go[WIDTH - 1] ^ add_sub;
        end
    endgenerate


endmodule
