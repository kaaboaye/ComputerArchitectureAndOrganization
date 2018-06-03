# Exercise 6
- Author: Mieszko Wawrzyniak 243563
- Date: 26 April 2018
- [Source code](https://raw.githubusercontent.com/kaaboaye/ComputerArchitectureAndOrganization/master/Lab6/main.asm)

## Task
Introductory classes, familiarize yourself with tools used during laboratory
from assembler programming. Running the sample program “Hello Word”.

## Conclusions
- In order to print string we should use static memory which in mips assembly
  is in `.data` section.
- Syscall number 4 prints string given in register `$a0`.
