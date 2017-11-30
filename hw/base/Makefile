TARGET := top
TARGET_TB := tb

SRC :=
SRC += def.svh
SRC += top.sv

RTL :=
RTL += dut.sv
RTL += ifc.sv

TB :=
TB += tb.sv
TB += env.sv
TB += sv

CPP_TB := tb.cpp

all: $(TARGET)

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
# VRL_SRC := --trace fq.sv --exe fq_tb.cpp

INCDIR = -I./rtl -I./tb


vcs: $(ALL_SRC) ## Make target - VCS
	$(VCS) $(VCS_FLAGS) 

verilator: $(ALL_SRC) ## Make Target - Verilator 
	$(VRL) $(VRL_FLAGS) --trace rtl/dut.sv --exe tb/$(CPP_TB)
	make -j -C obj_dir/ -f Vdut.mk Vdut
	./obj_dir/Vdut


vivado: $(ALL_SRC) ## Build and simulate design on Xilinx Vivado
	xvlog --sv -d CC_VIVADO -i rtl/ -i tb/ pp_def.svh pp_top.sv rtl/pp.sv rtl/pp_ifc.sv tb/pp_env.sv tb/pp_tb.sv tb/pp_trans.sv
	xelab -debug typical pp_top -s pp_top_sim

modelsim: $(ALL_SRC) ## Build and simulate design on Altera Modelsim
	vlib rtl_work
	vmap work rtl_work
	vlog +incdir+rtl +incdir+tb +define+CC_MODELSIM +define+DEBUG $(SRC) ./tb/$(TARGET_TB).sv
	vsim -c -do "vcd file $(TARGET).vcd; vcd add -r *; run -all"  $(TARGET) > $(TARGET).log
	awk 'BEGIN{IGNORECASE=1} /fail| error/ && !/# Errors: 0, Warnings: 0/ { print }' $(TARGET).log

clean: ## Clean build files 
	rm -f *.o $(TARGET) *.vcd modelsim.ini
	rm -rf work rtl_work *.log transcript vsim.wlf
	rm -rf xsim.dir *.pb
	rm -rf obj_dir
	find -name "*.jou" | xargs rm -rf
	find -name "*.log" | xargs rm -rf

gtk: ## View waveform with gtk
	$(GTK) $(TARGET).vcd

scansion: ## View waveform with scansion
	$(SCANSION) dut.vcd

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean wave modelsim vcs verilator
