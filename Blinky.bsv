package Blinky;

import StmtFSM::*;
import TestUtils::*;

interface Blinky #(numeric type clk_f);
    (* always_ready, always_enabled *)
    method Bit#(1) led();
endinterface

module mkBlinky (Blinky#(clk_f))
        provisos (Log#(clk_f, count_sz),
                  Add#(reload_sz, 1, count_sz));
    let reload = fromInteger(valueof(clk_f) / 2 - 1);

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
    Blinky#(12_000_000) blinky <- mkBlinky();

    mkAutoFSM(seq
        repeat(5_999_999) assert_not_set(blinky.led(), "Error, led should not yet be set");
        repeat(6_000_000) assert_set(blinky.led(), "Error, led should be set");
        repeat(6_000_000) assert_not_set(blinky.led(), "Error, led should not yet be set");
        repeat(6_000_000) assert_set(blinky.led(), "Error, led should be set");
        $display("BlinkyTest: PASS");
    endseq);
endmodule


endpackage
