# MIPS16 implementation on the Basys3

This projects is an implementation of the MIPS16 (16 bits instructions) on the Basys3 board. To demonstrate the fucntionallity, a simple demo program is loaded in the instruction memory.

```
addi r1, r0, 5
addi r2, r0, 10

add r3, r1, r2
sub r3, r3, r1

and r3, r1, r2
or r3, r1, r2
xor r2, r1, r3
nor r4, r3, r1

sll r3, r1, 1
srl r3, r2, 1

andi r3, r1, 0F
ori r3, r2, 0F

sw r3, 0(r1)
lw r2, 0(r1)

beq r3, r2, 1
addi r3, r0, 123

j 0
```
