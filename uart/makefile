%.hex: %.asm
	avra -fI $<
	rm *.obj *.eep.hex *.cof

compile: run.hex

upload: run.hex
	avrdude -c arduino -p m328p -P /dev/ttyACM0 -b 115200 -U flash:w:$<

monitor: 
	minicom -D /dev/ttyACM0 -b 9600

.PHONY: prepare compile
