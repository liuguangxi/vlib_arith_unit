//==============================================================================
// AU_prefix_and_or.v
//
// Prefix structures of different depth (i.e. speed) for carry calculation
// in binary adders. Compute in M levels new generate/propagate signal pairs
// for always larger groups of bits. Generate signals of last level correspond
// to carries in binary addition.
// Basic logic operation: AND-OR for generate signals,
// AND for propagate signals.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_prefix_and_or #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] gi,  // generate input data
    input  [WIDTH-1:0] pi,  // propagate input data
    output [WIDTH-1:0] go,  // generate output data
    output [WIDTH-1:0] po   // propagate output data
);


    // Calculate max(ceil(log2(x)), 1)
    function integer clogb2(input integer value);
        begin
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
            if (clogb2 < 1) clogb2 = 1;
        end
    endfunction


    // Structural model
    generate
        if (ARCH == 0) begin : g_ser
            // Serial-prefix propagate-lookahead structure
            genvar i;
            wire [WIDTH-1:0] gt;
            wire [WIDTH-1:0] pt;

            assign gt[0] = gi[0];
            assign pt[0] = pi[0];
            for (i = 1; i <= WIDTH - 1; i = i + 1) begin : g_bits
                assign gt[i] = gi[i] | (pi[i] & gt[i - 1]);
                assign pt[i] = pi[i] & pt[i - 1];
            end
            assign go = gt;
            assign po = pt;
        end

        if (ARCH == 1) begin : g_bk
            // Brent-Kung parallel-prefix propagate-lookahead structure
            localparam integer N = WIDTH;
            localparam integer M = clogb2(WIDTH);
            genvar l, k, i;
            wire [N-1:0] gt[0:2*M-1];
            wire [N-1:0] pt[0:2*M-1];

            assign gt[0] = gi;
            assign pt[0] = pi;
            for (l = 1; l <= M; l = l + 1) begin : g_levels1
                for (k = 0; k <= 2 ** (M - l) - 1; k = k + 1) begin : g_groups
                    for (i = 0; i <= 2 ** l - 2; i = i + 1) begin : g_bits
                        if (k * 2 ** l + i < N) begin : g_white
                            assign gt[l][k * 2 ** l + i] = gt[l - 1][k * 2 ** l + i];
                            assign pt[l][k * 2 ** l + i] = pt[l - 1][k * 2 ** l + i];
                        end
                    end
                    if (k * 2 ** l + 2 ** l - 1 < N) begin : g_black
                        assign gt[l][k * 2 ** l + 2 ** l - 1] =
                            gt[l - 1][k * 2 ** l + 2 ** l - 1] |
                            (pt[l - 1][k * 2 ** l + 2 ** l - 1] &
                            gt[l - 1][k * 2 ** l + 2 ** (l - 1) - 1]);
                        assign pt[l][k * 2 ** l + 2 ** l - 1] =
                            pt[l - 1][k * 2 ** l + 2 ** l - 1] &
                            pt[l - 1][k * 2 ** l + 2 ** (l - 1) - 1];
                    end
                end
            end
            for (l = M + 1; l <= 2 * M - 1; l = l + 1) begin : g_levels2
                for (i = 0; i <= 2 ** (2 * M - l) - 1; i = i + 1) begin : g_bits
                    if (i < N) begin : g_white
                        assign gt[l][i] = gt[l - 1][i];
                        assign pt[l][i] = pt[l - 1][i];
                    end
                end
                for (k = 1; k <= 2 ** (l - M) - 1; k = k + 1) begin : g_groups
                    if (l < 2 * M - 1) begin : g_empty
                        for (i = 0; i <= 2 ** (2 * M - l - 1) - 2; i = i + 1) begin : g_bits
                            if (k * 2 ** (2 * M - l) + i < N) begin : g_white
                                assign gt[l][k * 2 ** (2 * M - l) + i] = gt[l - 1][k * 2 ** (2 * M - l) + i];
                                assign pt[l][k * 2 ** (2 * M - l) + i] = pt[l - 1][k * 2 ** (2 * M - l) + i];
                            end
                        end
                    end
                    if (k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1 < N) begin : g_black
                        assign gt[l][k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1] =
                            gt[l - 1][k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1] |
                            (pt[l - 1][k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1] &
                            gt[l - 1][k * 2 ** (2 * M - l) - 1]);
                        assign pt[l][k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1] =
                            pt[l - 1][k * 2 ** (2 * M - l) + 2 ** (2 * M - l - 1) - 1] &
                            pt[l - 1][k * 2 ** (2 * M - l) - 1];
                    end
                    for (i = 2 ** (2 * M - l - 1); i <= 2 ** (2 * M - l) - 1; i = i + 1) begin : g_bits
                        if (k * 2 ** (2 * M - l) + i < N) begin : g_white
                            assign gt[l][k * 2 ** (2 * M - l) + i] = gt[l - 1][k * 2 ** (2 * M - l) + i];
                            assign pt[l][k * 2 ** (2 * M - l) + i] = pt[l - 1][k * 2 ** (2 * M - l) + i];
                        end
                    end
                end
            end
            assign go = gt[2*M-1];
            assign po = pt[2*M-1];
        end

        if (ARCH == 2) begin : g_sk
            // Sklansky parallel-prefix propagate-lookahead structure
            localparam integer N = WIDTH;
            localparam integer M = clogb2(WIDTH);
            genvar l, k, i;
            wire [N-1:0] gt[0:M];
            wire [N-1:0] pt[0:M];

            assign gt[0] = gi;
            assign pt[0] = pi;
            for (l = 1; l <= M; l = l + 1) begin : g_levels
                for (k = 0; k <= 2 ** (M - l) - 1; k = k + 1) begin : g_groups
                    for (i = 0; i <= 2 ** (l - 1) - 1; i = i + 1) begin : g_bits
                        if (k * 2 ** l + i < N) begin : g_white
                            assign gt[l][k * 2 ** l + i] = gt[l - 1][k * 2 ** l + i];
                            assign pt[l][k * 2 ** l + i] = pt[l - 1][k * 2 ** l + i];
                        end
                        if (k * 2 ** l + 2 ** (l - 1) + i < N) begin : g_black
                            assign gt[l][k * 2 ** l + 2 ** (l - 1) + i] =
                                gt[l - 1][k * 2 ** l + 2 ** (l - 1) + i] |
                                (pt[l - 1][k * 2 ** l + 2 ** (l - 1) + i] &
                                gt[l - 1][k * 2 ** l + 2 ** (l - 1) - 1]);
                            assign pt[l][k * 2 ** l + 2 ** (l - 1) + i] =
                                pt[l - 1][k * 2 ** l + 2 ** (l - 1) + i] &
                                pt[l - 1][k * 2 ** l + 2 ** (l - 1) - 1];
                        end
                    end
                end
            end
            assign go = gt[M];
            assign po = pt[M];
        end
    endgenerate


endmodule
