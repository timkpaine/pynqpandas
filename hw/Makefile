#################################################################################
#										#
#										#
#################################################################################


TARGET := pp_top
TARGET_TB := pp_tb

all: $(TARGET)

WAVE_VIEWER := gtkwave
WAVE_VIEWER := /Applications/Scansion.app/Contents/MacOS/Scansion

VCS := vcs
VRL := verilator
IVL := iverilog
COMPILER=verilator

.SUFFIXES: .hpp .cpp .cc .h .c .o .opp .so

# vcs flags
VCS_FLAGS :=
VCS_FLAGS += -sv --debug --trace

# verilator flags
VRL_FLAGS :=  -cc

# iverilog flags
IVL_FLAGS :=
IVL_FLAGS += -g2012 -D CC_IVERILOG

# LIBDIR = -L.
INCDIR = -I./rtl -I./tb

# LD_FLAGS :=
# ALL_LIBS   :=
# ALL_LIBS   := ${LIBS} ${LIBDIR}

ALL_SRC:=
ALL_SRC+=pp_top.sv


vcs: $(ALL_SRC) ## Make target - VCS
	$(VCS) $(VCS_FLAGS) 

iverilog: $(ALL_SRC) ## Make target - IVerilog
	$(IVL) $(IVL_FLAGS) -o $(TARGET) $(INCDIR) $(ALL_SRC) 

verilator: $(ALL_SRC) ## Make Target - Verilator 
	$(VRL) $(VRL_FLAGS) -o $(TARGET) $(INCDIR) $(ALL_SRC) 


$(TARGET): $(ALL_SRC) ## Make target
	$(CC) $(CC_FLAGS) -o $(TARGET) $(INCDIR) $(ALL_SRC) 


vivado: $(ALL_SRC) ## Build and simulate design on Xilinx Vivado
	vivado -mode batch -source v/synth.tcl

modelsim: $(ALL_SRC) ## Build and simulate design on Altera Modelsim
	vlib rtl_work
	vmap work rtl_work
	vlog +incdir+rtl +incdir+tb  +define+CC_MODELSIM +define+DEBUG $(ALL_SRC) ./tb/$(TARGET_TB).sv
	vsim -c -do "vcd file $(TARGET).vcd; vcd add -r *; run -all"  $(TARGET) > $(TARGET).log
	awk 'BEGIN{IGNORECASE=1} /fail| error/ && !/# Errors: 0, Warnings: 0/ { print }' $(TARGET).log

# modelsim_pe: $(ALL_SRC) ## Build and simulate design on Modelsim PE
#	vlib rtl_work
#	vmap work rtl_work
#	vlog +incdir+rtl +incdir+tb  +define+CC_MODELSIM -cover bcst $(ALL_SRC) ./tb/$(TARGET_TB).sv
#	vsim -c -do "vcd file $(TARGET).vcd; vcd add -r *; coverage report -file cover.dat -lines; run -all"  -coverage  $(TARGET) > $(TARGET).log
#	awk 'BEGIN{IGNORECASE=1} /fail| error/ && !/# Errors: 0, Warnings: 0/ { print }' $(TARGET).log

clean: ## Clean build files 
	rm -f *.o $(TARGET) *.vcd modelsim.ini
	rm -rf work rtl_work *.log transcript vsim.wlf
	rm -rf xsim.dir xvlog.pb
	rm -rf obj_dir


wave: ## View waveform
	$(WAVE_VIEWER) $(TARGET).vcd

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean wave modelsim iverilog vcs verilator
