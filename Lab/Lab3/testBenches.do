vlog -reportprogress 500 -work work datamemory.t.v datamemory.v register_file.t.v register_file.v instructiondecoder.t.v instructiondecoder.v mux32.t.v mux5.t.v allModules.t.v
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
sim:/allTestBenchesHarness/mux5Done 
run -all

wave zoom full