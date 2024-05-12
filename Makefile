VERILOG = ~/bsc/src/Verilog/

test:
	bsc -sim -g mkBlinkyTest -u -check-assert Blinky.bsv
	bsc -sim -e mkBlinkyTest -o test
	./test

build:
	bsc -u -verilog -g mkTop Icebreaker.bsv

pnr:
	yosys -p 'read_verilog -sv mkTop.v pll.v $(VERILOG)/ResetEither.v $(VERILOG)/SyncReset0.v' -p 'synth_ice40 -top mkTop -json mkTop.json'
	nextpnr-ice40 --up5k --package sg48 --json mkTop.json --pcf icebreaker.pcf --asc mkTop.asc
	icepack mkTop.asc mkTop.bin
	icetime -d up5k mkTop.asc

prog:
	iceprog mkTop.bin
