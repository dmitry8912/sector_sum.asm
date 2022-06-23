### Assembler sector summator
sum.asm gets first and second sector of the floppy drive, calculates the sum, and writes it into 3, 4 sectors

#### main.py
Script, created for initialize first two 512-bytes sectors, and clears the result
Usage:
``main.py -f "C:\Program Files\emu8086\FLOPPY_0" -m [sc|sw]
``
Parameter `sw` - write sectors (first two 512-bytes, than zeros)

Parameter `sc` - check sum

.asm prepared for emu8086