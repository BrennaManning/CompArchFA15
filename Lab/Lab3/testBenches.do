vlog -reportprogress 500 -work work datamemory.t.v datamemory.v register_file.t.v register_file.v instructiondecoder.t.v instructiondecoder.v mux32.t.v mux5.t.v pc_register.t.v ra_register.t.v alu_lab1.t.v shift_left.t.v concatenate.t.v sign_extend.t.v allModules.t.v
vsim -voptargs="+acc" allTestBenchesHarness

add wave -position insertpoint  \
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