# Exercise 9
- Author: Mieszko Wawrzyniak 243563
- Date: 24 May 2018
- [Source code](https://raw.githubusercontent.com/kaaboaye/ComputerArchitectureAndOrganization/master/Lab9/lab9.asm)

## Task
  Vectors with a large number of zeros are called sparse vectors. They are
  usually stored in a special form: order vector and the vector of values.
  Order vector indicates that the vector coordinates take the non-zero value
  in the following way: the occurrence of "1" in the order vector means that
  the corresponding position of the vector has a value different from zero,
  while the occurrence of "0" means that the coordinate has a value zero. The
  vector of values is a vector of nonzero coordinate values of the vector.
  Write a program that reads the sparse vectors stored in a standardized form,
  converts it to the form described above and calculates the value of their
  scalar product (use vectors in the new form).

## Program description
  Program is divided into 5 procedures.
  1. A standard `main` function which is calling others functions.
  2. `read_vector_size` which reads a size of a vectors then allocates
    required memory.
  3. `read_vector` which reads vector dimensions to the memory taking into
    account redundancy of storing `0` values.
  4. `print_vector` which prints given vector from the memory.
  5. `dot_product` which evaluates and prints dot product of two given
    vectors.

## Conclusions
  - This method of vector storage can be used in order to decrease required
    memory.
  - It's important to prevent redundant multiplications because there are
    relatively long operations.
