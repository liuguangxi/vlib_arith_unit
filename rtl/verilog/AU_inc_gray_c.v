//==============================================================================
// AU_inc_gray_c.v
//
// Incrementer for Gray numbers using parallel-prefix propagate-lookahead logic
// with carry-in.
// Bases on the following algorithm (n >= 3):
//     p = a(n-1) xor a(n-2) xor ... xor a(0)
//     z(0) = a(0) xnor p
//     z(i) = a(i) xor (a(i-1) and not a(i-2) and not a(i-3) ...
//                             and not a(0) and p)             ; i = 1, ..., n-2
//     z(n-1) = a(n-1) xor (not a(n-3) and not a(n-4) ... and not a(0) and p)
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_inc_gray_c #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,   // Gray coded input data
    input              ci,  // carry-in
    output [WIDTH-1:0] z    // Gray coded output data
);


    // Structural model
    generate
        wire p;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] po;
        wire [WIDTH-1:0] t1;
        wire [WIDTH-1:0] t2;

        // Calculate parity bit p
        assign p = ^a;

        // Calculate prefix input propagate signal (pi = not a(i))
        if (WIDTH >= 3) begin : g_pi_1
            assign pi[WIDTH - 2 : 1] = ~a[WIDTH - 3 : 0];
        end

        if (WIDTH >= 2) begin : g_pi_2
            // Feed slow p signal into prefix circuit for slow architecture
            if (ARCH == 0) begin : g_arch_0
                assign pi[0] = p & ci;
            end else begin : g_arch_gt0
                assign pi[0] = ci;
            end
        end

        // Calculate prefix output prop. signal (po = not a(i-2) ... and not a(0))
        if (WIDTH >= 2) begin : g_po
            AU_prefix_and #(
                .WIDTH(WIDTH - 1),
                .ARCH (ARCH)
            ) u_AU_prefix_and (
                .pi(pi[WIDTH-2:0]),
                .po(po[WIDTH-2:0])
            );
        end

        if (WIDTH >= 4) begin : g_t1_1
            assign t1[WIDTH - 2 : 2] = a[WIDTH - 3 : 1] & po[WIDTH - 3 : 1];
        end
        if (WIDTH >= 3) begin : g_t1_2
            assign t1[WIDTH - 1] = po[WIDTH - 2];
        end

        if (WIDTH >= 3) begin : g_t2_1
            if (ARCH == 0) begin : g_arch_0
                assign t2[WIDTH - 1 : 2] = t1[WIDTH - 1 : 2];
            end else begin : g_arch_gt0
                assign t2[WIDTH - 1 : 2] = t1[WIDTH - 1 : 2] & {(WIDTH - 2) {p}};
            end
        end
        if (WIDTH == 2) begin : g_t2_2
            assign t2[1] = p & ci;
        end
        if (WIDTH >= 3) begin : g_t2_3
            assign t2[1] = a[0] & p & ci;
        end
        if (WIDTH == 1) begin : g_t2_4
            assign t2[0] = ci;
        end else begin : g_t2_4
            assign t2[0] = (~p) & ci;
        end

        // Calculate result bits
        assign z = a ^ t2;
    endgenerate


endmodule
