//==============================================================================
// tb_AU_decode.sv
//
// Testbench of module AU_decode.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_decode;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 3;  // word length of input
    parameter integer Arch = 0;  // architecture


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // input data
    logic [2**Width-1:0] z;  // decoded output data
    logic [2**Width-1:0] z_ref;  // reference decoded output data
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_decode #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut (
        .a(a),
        .z(z)
    );

    AU_decode_ref #(
        .WIDTH(Width),
        .ARCH (Arch)
    ) dut_ref (
        .a(a),
        .z(z_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in);
        #(Cycle);
        a = a_in;

        #(Cycle);
        num_test++;
        if (z !== z_ref) begin
            $display("Fail    a(d_%0d)  z(h_%0h)  z_ref(h_%0h)", a, z, z_ref);
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
            test_single(a_in);
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

        #(Cycle * 10);
        test_exhaustive;

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
        $display("[INFO]  Simulation parameters: Width = %0d, Arch = %0d", Width, Arch);

        run_sim;

        $finish;
    end
    //------------------------------------------------------------------------------


endmodule
