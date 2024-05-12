// Adapted from: 
//  https://github.com/oxidecomputer/cobalt/blob/0fadc2c05ad0a8b6763ca30bd14ea034341171c7/hdl/examples/Blinky.bsv
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

package Blinky;

import StmtFSM::*;
import TestUtils::*;

interface Blinky #(numeric type clk_f, numeric type blk_f);
    (* always_ready, always_enabled *)
    method Bit#(1) led();
endinterface

/// Blink a led at frequency [blk_f] in Hz.
/// Note that [blk_f] must divide [clk_f].
module mkBlinky (Blinky#(clk_f, blk_f))
        provisos (Log#(clk_f, count_sz),
                  Add#(reload_sz, 1, count_sz),
                  Mul#(blk_f, div_f, clk_f));

    let reload = fromInteger(valueof(div_f) / 2 - 1);
    Reg#(UInt#(reload_sz)) ctr <- mkReg(reload);
    Reg#(Bit#(1)) lit <- mkReg(0);

    (* no_implicit_conditions, fire_when_enabled *)
    rule do_blink;
        let zero = ctr == 0;
        ctr <= zero ? reload : ctr - 1;
        lit <= zero ? ~lit : lit;
    endrule

    method led = lit;
endmodule

module mkBlinkyTest (Empty);
    Blinky#(12_000_000, 1) blinky <- mkBlinky();

    mkAutoFSM(seq
        repeat(5_999_999) assert_not_set(blinky.led(), "Error, led should not yet be set");
        repeat(6_000_000) assert_set(blinky.led(), "Error, led should be set");
        repeat(6_000_000) assert_not_set(blinky.led(), "Error, led should not yet be set");
        repeat(6_000_000) assert_set(blinky.led(), "Error, led should be set");
    endseq);

    Blinky#(12_000_000, 5) blinky5 <- mkBlinky();

    mkAutoFSM(seq
        repeat(2_399_999) assert_not_set(blinky5.led(), "Error, led should not yet be set");
        repeat(2_400_000) assert_set(blinky5.led(), "Error, led should be set");
        repeat(2_400_000) assert_not_set(blinky5.led(), "Error, led should not yet be set");
        repeat(2_400_000) assert_set(blinky5.led(), "Error, led should be set");
    endseq);

    mkAutoFSM(seq
        $display("BlinkyTest: PASS");
    endseq);

endmodule

endpackage
