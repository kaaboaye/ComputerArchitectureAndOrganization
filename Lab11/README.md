# Exercise 11
- Author: Mieszko Wawrzyniak 243563
- Date: 7 June 2018
- [Source code](https://raw.githubusercontent.com/kaaboaye/ComputerArchitectureAndOrganization/master/Lab11/lab11.asm)

## Task
Implement the matrix multiplication algorithm for rectangular matrices. Matrixes size can be specified in any way.

## Program description
Program stores 3 matrices in static memory in the following way:
```c++
struct Matrix {
  int row;
  int col;
  int *arr;
};

static Matrix matrix_a;
static Matrix matrix_b;
static Matrix matrix_c;
```
For the first two matrices program calls the following procedures `new_matrix`, `read_matrix` and `print_matrix`.

Procedure `new_matrix` reads from input amount of rows and columns of matrix then allocates memory required to store the matrix. Memory is allocated on the heap and pointer to the memory is stored in the structure `Matrix`.

Procedure `read_matrix` reads from input and stores in RAM all matrix elements.

Procedure `print_matrix` prints given matrix to the standard output.

When matrices `a` and `b` are ready program is checking whether it is possible to multiply these matrices. If not it prints an error and exits.

If everything is fine program
- allocates memory
- fills `matrix_c` memory witch zeros
- starts multiplication using a following algorithm.

```c
for (int row = 0; row < matrix_c.row; ++row) {
  for (int col = 0; col < matrix_c.col; ++col) {
    for (int node = 0; node < matrix_a.col; ++ node) {
      matrix_c.arr[row][col] +=
        matrix_a.arr[row][node] * matrix_b.arr[node][col];
    }
  }
}
```

After multiplication is completed program prints the result and exits.
