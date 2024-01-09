//==============================================================================
// AU_lead_sign_det.v
//
// Detection of leading signs (i.e. leading-zeroes/ones detection for signed
// numbers). Output vector indicates position of the least significant
// (right-most) sign bit. The least significant sign bit is the first bit
// starting from the most significant bit that differs from the next lower bit.
// Examples: a = "000101" -> z = "001000", a = "111010" -> z = "001000".
// Use the `AU_encode' component for encoding the output (-> z = "010").
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_lead_sign_det #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // input data
    output [WIDTH-1:0] z   // one-hot decoded output data
);


    // Structural model
    generate
        genvar i;
        wire [WIDTH-1:0] ps;
        wire [WIDTH-1:0] pi;
        wire [WIDTH-1:0] pit;
        wire [WIDTH-1:0] pot;
        wire [WIDTH-1:0] po;

        // Preprocess sign bit of input a
        assign ps[0] = 1'b1;
        if (WIDTH >= 2) begin : g_pi
            assign ps[WIDTH-1:1] = {(WIDTH - 1) {a[WIDTH-1]}} ^ a[WIDTH-2:0];
        end

        // Calculate prefix propagate in signals
        assign pi = ~ps;

        // Reverse bit order of pi
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_rev_pi
            assign pit[i] = pi[WIDTH - 1 - i];
        end

        // Solve reverse prefix problem for leading zeros detection
        AU_prefix_and #(
            .WIDTH(WIDTH),
            .ARCH (ARCH)
        ) u_AU_prefix_and (
            .pi(pit),
            .po(pot)
        );

        // Reverse bit order of po
        for (i = 0; i <= WIDTH - 1; i = i + 1) begin : g_rev_po
            assign po[i] = pot[WIDTH - 1 - i];
        end

        // Decode output: only bit indicating position of first '1' is '1'
        assign z[WIDTH - 1] = ps[WIDTH - 1];
        if (WIDTH >= 2) begin : g_z
            assign z[WIDTH - 2 : 0] = po[WIDTH - 1 : 1] & ps[WIDTH - 2 : 0];
        end
    endgenerate


endmodule
