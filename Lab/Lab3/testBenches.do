vlog -reportprogress 500 -work work datamemory.t.v datamemory.v register_file.t.v register_file.v instructiondecoder.t.v instructiondecoder.v mux32.t.v mux32.v mux5.t.v mux5.v pc_register.t.v pc_register.v ra_register.t.v ra_register.v alu_lab1.t.v alu_lab1.v shift_left.t.v shift_left.v concatenate.t.v concatenate.v sign_extend.t.v sign_extend.v allModules.t.v
vsim -voptargs="+acc" allTestBenchesHarness

add wave -position insertpoint \
sim:/allTestBenchesHarness/startTests \
sim:/allTestBenchesHarness/dataMemoryDUT \
sim:/allTestBenchesHarness/dataMemoryDone \
sim:/allTestBenchesHarness/registerFileDone \
sim:/allTestBenchesHarness/registerFileDUT \
sim:/allTestBenchesHarness/instructionDecoderDUT \
sim:/allTestBenchesHarness/instructionDecoderDone \
sim:/allTestBenchesHarness/mux32DUT \
sim:/allTestBenchesHarness/mux32Done \
sim:/allTestBenchesHarness/mux5DUT \
sim:/allTestBenchesHarness/mux5Done \
sim:/allTestBenchesHarness/pcDUT \
sim:/allTestBenchesHarness/pcDone \
sim:/allTestBenchesHarness/raDUT \
sim:/allTestBenchesHarness/raDone \
sim:/allTestBenchesHarness/aluDUT \
sim:/allTestBenchesHarness/aluDone \
sim:/allTestBenchesHarness/shiftLeftDUT \
sim:/allTestBenchesHarness/shiftLeftDone \
sim:/allTestBenchesHarness/concatenateDUT \
sim:/allTestBenchesHarness/concatenateDone \
sim:/allTestBenchesHarness/signExtendDUT \
sim:/allTestBenchesHarness/signExtendDone

run -all

wave zoom full