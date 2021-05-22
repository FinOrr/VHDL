onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Clock_Generator -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Clock_Generator xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Clock_Generator.udo}

run -all

endsim

quit -force
