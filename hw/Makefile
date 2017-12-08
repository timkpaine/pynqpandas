TARGET := top
TARGET_TB := ./tb/tb.sv

DUT := ./rtl/dut.sv

RTL :=
RTL += $(DUT)
RTL += ./rtl/ifc.sv
RTL += ./rtl/wrapper.sv

TB :=
TB += ./tb/tb.sv
TB += ./tb/env.sv
TB += ./tb/trans.sv

SRC :=
SRC += def.svh
SRC += top.sv
SRC += $(RTL)
SRC += $(TB)

CPP_SRC := 
CPP_TB := ./tb/src/tb.cpp

GTK := gtkwave
SCANSION := /Applications/Scansion.app/Contents/MacOS/Scansion

VCS := vcs
VRL := verilator
MS := modelsim
VS := vivado

.SUFFIXES: .hpp .cpp .cc .h .c .o .opp .so

# vcs flags
VCS_FLAGS :=
VCS_FLAGS += -sv --debug --trace -D CC_VCS

# verilator flags
VRL_FLAGS :=  -Wall --cc  +define+CC_VERILATOR=1

INCDIR = -I./rtl -I./tb


vcs: $(ALL_SRC) ## Make target - VCS
	$(VCS) $(VCS_FLAGS) 

verilator: $(ALL_SRC) ## Make Target - Verilator 
	$(VRL) $(VRL_FLAGS) --trace $(DUT) --exe $(CPP_SRC) tb/src/dut.cpp $(CPP_TB)
	make -j -C obj_dir/ -f Vdut.mk Vdut
	./obj_dir/Vdut

relay: $(ALL_SRC) # FIXME
	$(VRL) $(VRL_FLAGS) --trace rtl/relay.sv --exe $(CPP_SRC) tb/src/relay.cpp tb/src/relay_tb.cpp
	make -j -C obj_dir/ -f Vrelay.mk Vrelay
	./obj_dir/Vrelay

vivado: $(ALL_SRC) ## Build and simulate design on Xilinx Vivado
	xvlog --sv -d CC_VIVADO -i rtl/ -i tb/ $(DUT) ./tb/tb.sv
	xelab -debug typical tb -s tb_sim
	xsim tb_sim --R > $(TARGET).log
	awk 'BEGIN{IGNORECASE=1} /fail| error/ && !/# Errors: 0, Warnings: 0/ { print }' $(TARGET).log


modelsim: $(ALL_SRC) ## Build and simulate design on Altera Modelsim
	vlib rtl_work
	vmap work rtl_work
	vlog +incdir+rtl +incdir+tb +define+CC_MODELSIM +define+DEBUG $(SRC) $(TARGET_TB)
	vsim -c -do "vcd file dut.vcd; vcd add -r *; run -all"  $(TARGET) > $(TARGET).log
	awk 'BEGIN{IGNORECASE=1} /fail| error/ && !/# Errors: 0, Warnings: 0/ { print }' $(TARGET).log

clean: ## Clean build files 
	rm -f *.o $(TARGET) *.vcd modelsim.ini
	rm -rf work rtl_work *.log transcript vsim.wlf
	rm -rf xsim.dir *.pb tb_sim.wdb
	rm -rf obj_dir
	find . -name "*.jou" | xargs rm -rf
	find . -name "*.log" | xargs rm -rf

gtk: ## View waveform with gtk
	$(GTK) dut.vcd

scansion: ## View waveform with scansion
	$(SCANSION) dut.vcd

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean wave modelsim vcs verilator
