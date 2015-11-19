vdel - lib work - all
vlib work

vlog -reportprogress 300 -work work mux32.t.v
vsim -voptargs="+acc" mux32testharness

add wave -position insertpoint/  \
sim:/instructiondecodertestharness/muxcontrol \
sim:/instructiondecodertestharness/muxin1 \
sim:/instructiondecodertestharness/muxin2 \
sim:/instructiondecodertestharness/muxout \
sim:/instructiondecodertestharness/begintest \
sim:/instructiondecodertestharness/dutpassed \

run -all

wave zoom full