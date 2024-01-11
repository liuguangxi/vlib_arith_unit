//==============================================================================
// tb_AU_incdec.sv
//
// Testbench of module AU_incdec.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_incdec;


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
    logic inc_dec;  // control, 0:increment, 1:decrement
    logic [Width-1:0] z;  // increment or decrement
    logic [Width-1:0] z_ref;  // reference increment or decrement
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_incdec #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut (
        .a      (a),
        .inc_dec(inc_dec),
        .z      (z)
    );

    AU_incdec_ref #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut_ref (
        .a      (a),
        .inc_dec(inc_dec),
        .z      (z_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in, logic inc_dec_in);
        #(Cycle);
        a = a_in;
        inc_dec = inc_dec_in;

        #(Cycle);
        num_test++;
        if (z !== z_ref) begin
            $display("Fail    a(h_%0h)  z(h_%0h)  z_ref(h_%0h)", a, z, z_ref);
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
        logic inc_dec_in;
        int i;

        // Special tests
        test_single({Width{1'b0}}, 1'b0);
        test_single({Width{1'b0}}, 1'b1);
        test_single({Width{1'b1}}, 1'b0);
        test_single({Width{1'b1}}, 1'b1);

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(a_in));
            assert (std::randomize(inc_dec_in));
            test_single(a_in, inc_dec_in);
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
        inc_dec = 'b0;

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
