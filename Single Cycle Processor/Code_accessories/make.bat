rmdir -r build
mkdir build
riscv64-unknown-elf-as -c -o build/startup.o src/startup.s -march=rv32i -mabi=ilp32
riscv64-unknown-elf-gcc -c -O0 -o build/test.o src/test.c -march=rv32i -mabi=ilp32
riscv64-unknown-elf-gcc -o build/main.elf build/startup.o build/test.o -T linker.ld -nostdlib -march=rv32i -mabi=ilp32
riscv64-unknown-elf-objcopy -O binary --only-section=.data* --only-section=.text* build/main.elf build/main.bin
python maketxt.py build/main.bin > build/main.txt
riscv64-unknown-elf-objdump -S -s build/main.elf > build/main.dump