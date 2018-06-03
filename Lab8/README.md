# Exercise 8
- Author: Mieszko Wawrzyniak 243563
- Date: 17 May 2018
- [Source code](https://raw.githubusercontent.com/kaaboaye/ComputerArchitectureAndOrganization/master/Lab8/main.asm)

## Task
  1. Write a program which calculate the value of factorial of integer values.
    In program implementation use for loop.
  2. What is the greatest integer value for which your program work correctly?
    Explain your answer.

## Program description
  Program reads from the standard input integer value from which factorial
  will be calculated. Factorial is evaluated basing on the following c-language
  code.
  ```c
int factorial(int n) {
  int fac = 1;
  for (; n != 0; --n) {
    fac *= n;
  }
  return fac;
}
  ```
  The greatest integer value for which program works correctly is `2^31-1`
  which is equal to `2147483647`. This limitations is caused by following
  factors:
  - MIPS has 32-bit registers,
  - program uses signed integer which means that one bit is used for sign.
