## A 64-bit Arithmetic Logic Unit (ALU)

Functions can be controlled using the 'F' input signal:

    00 = A AND B
    01 = A OR B
    10 = NOT B
    11 = A + B (arithmetic)

The size of the ALU is defined by a generic so it's possible to resize the ALU to match the data widths required (e.g. 8-bit / 32-bit / 64-bit).
Includes a dedicated increment input so increment (++) functions can be completed efficiently.
