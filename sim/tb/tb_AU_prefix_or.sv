//==============================================================================
// tb_AU_prefix_or.sv
//
// Testbench of module AU_prefix_or.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_prefix_or;


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
    logic [Width-1:0] pi;  // propagate input data
    logic [Width-1:0] po;  // propagate output data
    logic [Width-1:0] po_ref;  // reference propagate output data
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_prefix_or #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut (
        .pi(pi),
        .po(po)
    );

    AU_prefix_or_ref #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut_ref (
        .pi(pi),
        .po(po_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] pi_in);
        #(Cycle);
        pi = pi_in;

        #(Cycle);
        num_test++;
        if (po !== po_ref) begin
            $display("Fail    pi(h_%0h)  po(h_%0h)  po_ref(h_%0h)", pi, po, po_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] pi_in;
        int i;

        // Exhaustive tests
        for (i = 0; i <= 2 ** Width - 1; i++) begin
            pi_in = i;
            test_single(pi_in);
        end
    endtask


    // Test random cases
    task automatic test_random;
        logic [Width-1:0] pi_in;
        int i;

        // Special tests
        test_single({Width{1'b0}});
        test_single({Width{1'b1}});

        // Random tests
        for (i = 1; i <= Nrandom; i++) begin
            assert (std::randomize(pi_in));
            test_single(pi_in);
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

        pi = 'b0;

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
