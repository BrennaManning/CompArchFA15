vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work instructiondecoder.t.v
vsim -voptargs="+acc" instructiondecodertestharness

add wave -position insertpoint/jal  \
sim:/instructiondecodertestharness/regdst \
sim:/instructiondecodertestharness/branch \
sim:/instructiondecodertestharness/jump \
sim:/instructiondecodertestharness/jr \
sim:/instructiondecodertestharness/memtoreg \
sim:/instructiondecodertestharness/memwrite \
sim:/instructiondecodertestharness/aluop \
sim:/instructiondecodertestharness/alusrc \
sim:/instructiondecodertestharness/regwrite \
sim:/instructiondecodertestharness/lsw \
sim:/instructiondecodertestharness/instruction \
sim:/instructiondecodertestharness/begintest \
sim:/instructiondecodertestharness/dutpassed \

run -all

wave zoom full