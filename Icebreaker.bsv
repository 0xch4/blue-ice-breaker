import Blinky::*;
import PLL::*;

import Clocks::*;

(* always_enabled *)
interface Icebreaker;
    method Bit#(5) leds;
endinterface

(* default_clock_osc="clk_12mhz" *)
module mkTop (Icebreaker);
    Clock clk_12mhz <- exposeCurrentClock;
    PLL pll <- mkPLL(clk_12mhz);

    Reset rst <- mkAsyncResetFromCR(0, pll.clk_48mhz);
    Reset rst_48mhz <- mkResetEither(rst, pll.rst_lock, clocked_by pll.clk_48mhz);

    Blinky#(48_000_000, 2) blinky <- Blinky::mkBlinky (clocked_by pll.clk_48mhz, reset_by rst_48mhz);
    ReadOnly#(Bit#(1)) led_status <- mkNullCrossingWire(noClock, blinky.led);

    method leds() = {led_status, 1'b0, led_status, led_status, led_status};
endmodule