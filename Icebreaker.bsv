import Blinky::*;

(* always_enabled *)
interface Top;
    method Bit#(5) led;
endinterface

(* default_clock_osc="clk_12mhz" *)
module mkTop (Top);
    Blinky#(12_000_000) blinky <- Blinky::mkBlinky();

    method led() = {blinky.led(), 1'b0, blinky.led(), blinky.led(), blinky.led()};
endmodule