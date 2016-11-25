.SUFFIXES: .S .o .elf .tmp .bin .dts .dtbo

CC8=aarch64-none-elf-gcc
LD8=aarch64-none-elf-ld
OBJCOPY8=aarch64-none-elf-objcopy
OBJDUMP8=aarch64-none-elf-objdump -maarch64
# Requires dtc with overlay support
DTC=dtc

all: psci overlay

overlay: psci.dtbo

psci: pscimon.bin

clean :
	rm -f *.o *.out *.tmp *.bin *.elf *~

.S.o:
	$(CC8) -c $< -o $@

.o.elf:
	$(LD8) --section-start=.text=0 $< -o $@

.elf.tmp:
	$(OBJCOPY8) $< -O binary $@

.tmp.bin:
	dd if=$< ibs=256 of=$@ conv=sync

.dts.dtbo:
	$(DTC)  -O dtb -o $@ -b 0 $<
