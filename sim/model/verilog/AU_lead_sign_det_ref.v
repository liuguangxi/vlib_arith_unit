//==============================================================================
// AU_lead_sign_det_ref.v
//
// Behavioral model of AU_lead_sign_det.
// Detection of leading signs (i.e. leading-zeroes/ones detection for signed
// numbers). Output vector indicates position of the least significant
// (right-most) sign bit. The least significant sign bit is the first bit
// starting from the most significant bit that differs from the next lower bit.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


module AU_lead_sign_det_ref #(
    parameter integer WIDTH = 8,  // word length of input (>= 1)
    parameter integer ARCH  = 0   // architecture (0 to 2)
) (
    // Data interface
    input  [WIDTH-1:0] a,  // input data
    output [WIDTH-1:0] z   // one-hot decoded output data
);


    // Behavioral model
    reg [WIDTH-1:0] zv;
    reg done;
    integer i;

    always @(*) begin
        zv = 'b0;
        done = 1'b0;
        for (i = WIDTH - 1; (done == 1'b0) && (i >= 1); i = i - 1) begin
            if (a[i] != a[i - 1]) begin
                zv[i] = 1'b1;
                done = 1'b1;
            end
        end
        if (zv == 'b0) zv[0] = 1'b1;
    end

    assign z = zv;


    // Parameter legality check
    initial begin : parameter_check
        integer param_err_flg;

        param_err_flg = 0;

        if (WIDTH < 1) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter WIDTH (lower bound: 1)", WIDTH);
        end

        if ((ARCH < 0) || (ARCH > 2)) begin
            param_err_flg = 1;
            $display("ERROR: %m :\n  Invalid value (%0d) for parameter ARCH (legal range: 0 to 2)", ARCH);
        end

        if (param_err_flg == 1) begin
            $display("%m :\n  Simulation aborted due to invalid parameter value(s)");
            $finish;
        end
    end


endmodule
