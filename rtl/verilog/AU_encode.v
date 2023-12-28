//==============================================================================
// AU_encode.v
//
// Encodes the position of a '1' in the input vector into a binary number.
// Example: a = "00100000" -> z = "101".
// Condition: exactly one bit of input vector A is '1'.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_encode #(
    parameter integer WIDTH = 8  // word length of input (>= 1)
) (
    // Data interface
    input  [        WIDTH-1:0] a,  // input data
    output [clogb2(WIDTH)-1:0] z   // encoded output data
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
        localparam integer N = WIDTH;
        localparam integer M = clogb2(WIDTH);
        genvar l;

        // Example: N = 8, M = 3
        //     z(0) = a(7) or a(5) or a(3) or a(1)
        //     z(1) = a(7) or a(6) or a(3) or a(2)
        //     z(2) = a(7) or a(6) or a(5) or a(4)
        // indices correspond to position of black nodes in Sklansky parallel-prefix algorithm
        for (l = 1; l <= M; l = l + 1) begin : g_bits
            reg zv;
            integer k, i;

            always @(*) begin
                zv = 1'b0;
                for (k = 0; k <= 2 ** (M - l) - 1; k = k + 1) begin
                    for (i = 0; i <= 2 ** (l - 1) - 1; i = i + 1) begin
                        if (k * 2 ** l + 2 ** (l - 1) + i < N) begin
                            zv = zv | a[k * 2 ** l + 2 ** (l - 1) + i];
                        end
                    end
                end
            end
            assign z[l - 1] = zv;
        end
    endgenerate


endmodule
