open_project /home/vagrant/pynqpandas/hw/v/pynqpandas.xpr
update_compile_order -fileset sources_1
synth_design -name "pp" -top "pp" -part "xc7z020clg400-1"
report_timing_summary