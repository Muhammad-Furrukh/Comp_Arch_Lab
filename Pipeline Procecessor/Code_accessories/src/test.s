addi x5, x0, 10      # Load immediate 10 into x5
addi x6, x0, 20      # Load immediate 20 into x6
add x7, x5, x6       # x7 = x5 + x6 (10 + 20 = 30)
lui x8, 0x80000      # Load upper immediate to test large numbers
sw x7, 0(x8)         # Store x7 (30) at memory location pointed by x8
lw x9, 0(x8)         # Load from memory into x9 (should load 30)
andi x10, x9, 15     # x10 = x9 & 15 (Bitwise AND with 15)
slli x11, x10, 2     # x11 = x10 << 2 (Shift left by 2)
xor x12, x11, x9     # x12 = x11 ^ x9 (XOR operation)
slti x13, x12, 50    # Set x13 to 1 if x12 < 50, else 0