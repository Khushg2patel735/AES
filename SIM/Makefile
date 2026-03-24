#makefile

RTL="../RTL/*.v"
TB="../TB/*.v"
TOP_MODULE=aes_top_tb

lib:
		vlib work

comp:
		vlog $(RTL) $(TB)
comp1: 
		vlog -coveropt 3 +acc +cover $(RTL) $(TB)

sim_gui:
		vsim -voptargs=+acc $(TOP_MODULE)

sim:
		vsim -voptargs=+acc $(TOP_MODULE) -c -do "run -all; exit"

sim1:
		vsim -coverage -voptargs=+acc $(TOP_MODULE) -c -do "coverage save -onexit -directive -cvg -codeall coverage.ucdb; run -all; exit"

report:
		vcover report -details -html -output $(TOP_MODULE) coverage.ucdb

sim_c: comp sim

runsim: comp1 sim1 report
