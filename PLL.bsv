interface PLL;
    interface Clock clk_48mhz;
    interface Reset rst_lock;
endinterface

import "BVI" pll =
    module mkPLL #(Clock clk_12mhz) (PLL);
        default_clock no_clock;   
        default_reset no_reset; 

        input_clock (clk_12mhz) = clk_12mhz;
        output_clock clk_48mhz(clk_48mhz);
        same_family(clk_12mhz, clk_48mhz);

        output_reset rst_lock(nlocked) clocked_by (clk_48mhz);
    endmodule