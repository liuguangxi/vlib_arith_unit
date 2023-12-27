//==============================================================================
// tb_AU_encode.sv
//
// Testbench of module AU_encode.
//------------------------------------------------------------------------------
// Copyright (c) 2023 Guangxi Liu
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
//==============================================================================


`timescale 1ns / 1ps


module tb_AU_encode;


    //------------------------------------------------------------------------------
    // Parameters
    parameter real Cycle = 10.0;  // unit cycle
    parameter integer Width = 8;  // word length of input


    // Global variables
    int num_test;
    int num_fail;


    // Signals
    logic [Width-1:0] a;  // input data
    logic [clogb2(Width)-1:0] z;  // encoded output data
    logic [clogb2(Width)-1:0] z_ref;  // reference encoded output data
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Instances
    AU_encode #(
        .WIDTH(Width)
    ) dut (
        .a(a),
        .z(z)
    );

    AU_encode_ref #(
        .WIDTH(Width)
    ) dut_ref (
        .a(a),
        .z(z_ref)
    );
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Calculate max(ceil(log2(x)), 1)
    function automatic integer clogb2(input integer value);
        begin
            value = value - 1;
            for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
            if (clogb2 < 1) clogb2 = 1;
        end
    endfunction
    //------------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Test single case
    task automatic test_single(logic [Width-1:0] a_in);
        #(Cycle);
        a = a_in;

        #(Cycle);
        num_test++;
        if (z !== z_ref) begin
            $display("Fail    a(h_%0h)  z(d_%0d)  z_ref(d_%0d)", a, z, z_ref);
            num_fail++;
        end
    endtask


    // Test exhaustive cases
    task automatic test_exhaustive;
        logic [Width-1:0] a_in;
        int i;

        // Special test
        a_in = 'b0;
        test_single(a_in);

        // Exhaustive tests
        for (i = 0; i <= Width - 1; i++) begin
            a_in = 'b0;
            a_in[i] = 1'b1;
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
        $display("[INFO]  Simulation parameters: Width = %0d", Width);

        run_sim;

        $finish;
    end
    //------------------------------------------------------------------------------


endmodule
