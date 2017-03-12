%.hex: %.asm
	avra -fI $<
	rm *.obj *.eep.hex *.cof

compile: run.hex

upload: run.hex
	avrdude -c arduino -p m328p -P /dev/arduino-uno -b 115200 -U flash:w:$<

monitor: 
	minicom -D /dev/arduino-uno -b 115200 

.PHONY: prepare compile
