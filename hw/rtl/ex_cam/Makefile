CAMTOP=cam_top.sv
CAMINTERFACE=cam_ifc.sv
CAMBENCH=cam_tb.sv
CAMDUT=cam.sv


FFTOP=ff_top.sv
FFINTERFACE=ff_ifc.sv
FFBENCH=ff_tb.sv
FFDUT=ff.sv

.PHONY: all
all: ffbench cambench

help:
	@echo "The following make targets are supported:" ;\
	echo " ffbench  - builds the testbench";\
	echo " cambench  - builds the testbench";\
	echo " wave   - convert vcd to vpd";\
	echo " clean  - cleans testbench and intermediate files" ;\
	echo " help   - show this information";\

cambench: 
	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE -notice $(CAMTOP) $(CAMINTERFACE) $(CAMBENCH) $(CAMDUT) priorityencoder.sv decoder.sv mux.sv equality_checker.sv ceff.sv register.sv -o camtestbench.exe

ffbench: 
	vcs -full64 -PP -sverilog +define+SV +define+VPD +lint=all,noVCDE -notice $(FFTOP) $(FFINTERFACE) $(FFBENCH) $(FFDUT) -o fftestbench.exe

wave:
	vcs -vpd2vcd vcdplus.vpd waveform.vcd
	gtkwave waveform.vcd &

clean:
	rm -rf *.o *~ *.vpd sim* csrc DVEfiles *daidir *exe *.key
