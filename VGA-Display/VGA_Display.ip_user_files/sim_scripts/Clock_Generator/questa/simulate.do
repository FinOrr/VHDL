onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Clock_Generator_opt

do {wave.do}

view wave
view structure
view signals

do {Clock_Generator.udo}

run -all

quit -force
