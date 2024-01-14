//==============================================================================
// tb_AU_inc_c.sv
//
// Testbench of module AU_inc_c.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_inc_c;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input
    parameter integer Arch = 0;  // architecture
    parameter integer Nrandom = 10000;  // number of random tests


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // input data
    logic ci;  // carry-in
    logic [Width-1:0] z;  // increment
    logic co;  // carry-out
    logic [Width-1:0] z_ref;  // reference increment
    logic co_ref;  // reference carry-out
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_inc_c #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut (
        .a (a),
        .ci(ci),
        .z (z),
        .co(co)
    );

    AU_inc_c_ref #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut_ref (
        .a (a),
        .ci(ci),
        .z (z_ref),
        .co(co_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in, logic ci_in);
        #(Cycle);
        a = a_in;
        ci = ci_in;

        #(Cycle);
        num_test++;
        if (z !== z_ref) begin
            $display("Fail    a(h_%0h)  ci(b_%0b)  z(h_%0h)  co(b_%0b)  z_ref(h_%0h)  co_ref(b_%0b)",
                     a, ci, z, co, z_ref, co_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] a_in;
        int i;

        // Exhaustive tests
        for (i = 0; i <= 2 ** Width - 1; i++) begin
            a_in = i;
            test_single(a_in, 1'b0);
            test_single(a_in, 1'b1);
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] a_in;
        logic ci_in;
        int i;

        // Special tests
        test_single({Width{1'b0}}, 1'b0);
        test_single({Width{1'b0}}, 1'b1);
        test_single({Width{1'b1}}, 1'b0);
        test_single({Width{1'b1}}, 1'b1);

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(a_in));
            assert (std::randomize(ci_in));
            test_single(a_in, ci_in);
        end
    endtask


    // Run simulation
    task automatic run_sim;
        localparam string StrPass = {
            "                   \n",
            "               #   \n",
            "              #    \n",
            "             #     \n",
            "     #      #      \n",
            "      #    #       \n",
            "       #  #        \n",
            "        ##         \n",
            "                   \n"
        };
        localparam string StrFail = {
            "                   \n",
            "    #           #  \n",
            "      #       #    \n",
            "        #   #      \n",
            "          #        \n",
            "        #   #      \n",
            "      #       #    \n",
            "    #           #  \n",
            "                   \n"
        };

        num_test = 0;
        num_fail = 0;

        a = 'b0;
        ci = 'b0;

        #(Cycle * 10);
        if (Width <= 16) begin
            test_exhaustive;
        end else begin
            test_random;
        end

        $display("[INFO]  Simulation complete.");
        if (num_fail == 0) begin
            $display("%s", StrPass);
            $display("PASS  (Total %0d)", num_test);
        end else begin
            $display("%s", StrFail);
            $display("FAIL  (Total %0d / Fail %0d)", num_test, num_fail);
        end
    endtask
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Main process
    initial begin
        $display("[INFO]  Simulation parameters: Width = %0d, Arch = %0d, Nrandom = %0d", Width, Arch, Nrandom);

        run_sim;

        $finish;
    end
    //------------------------------------------------------------------------------


endmodule
