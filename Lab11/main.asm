.data
  int_matrix_a_row: .word 0
  int_matrix_a_col: .word 0
  int_matrix_b_row: .word 0
  int_matrix_b_col: .word 0
  int_matrix_c_row: .word 0
  int_matrix_c_col: .word 0
  int_selected_col: .word 0

  int_for_row: .word 0
  int_for_col: .word 0
  int_for_key: .word 0

  int_accu: .word 0
  int_a: .word 0

  ptr_matrix_a: .word 0
  ptr_matrix_b: .word 0
  ptr_matrix_c: .word 0
  ptr_selected: .word 0

  s_endl: .asciiz "\n"
  s_space: .asciiz " "
  s_ask_size: .asciiz "Provide matrix size, rows then cols\n"
  s_ask_matrix: .asciiz "Provide matrix bellow\n"
  s_printing_matrix: .asciiz "Printing matrix...\n"
  s_bad_matrix_size: .asciiz "Bad matrix size\n"
  s_mult: .asciiz "Multiplying matrix\n"

  reg_mul_ra: .word 0

.text
  .globl main
  main:

    # Matrix A
    la $a0, int_matrix_a_row
    la $a1, int_matrix_a_col
    la $a2, ptr_matrix_a
    jal func_create_matrix

    lw $a0, int_matrix_a_row
    lw $a1, int_matrix_a_col
    lw $a2, ptr_matrix_a
    jal func_read_matrix

    lw $a0, int_matrix_a_row
    lw $a1, int_matrix_a_col
    lw $a2, ptr_matrix_a
    jal func_print_matrix

    # Matrix B
    la $a0, int_matrix_b_row
    la $a1, int_matrix_b_col
    la $a2, ptr_matrix_b
    jal func_create_matrix

    lw $a0, int_matrix_b_row
    lw $a1, int_matrix_b_col
    lw $a2, ptr_matrix_b
    jal func_read_matrix

    lw $a0, int_matrix_b_row
    lw $a1, int_matrix_b_col
    lw $a2, ptr_matrix_b
    jal func_print_matrix

    # Multiply
    jal func_mul

    # Print the result
    lw $a0, int_matrix_c_row
    lw $a1, int_matrix_c_col
    lw $a2, ptr_matrix_c
    jal func_print_matrix

    li $v0, 10
    syscall

  # $a0 & row size
  # $a1 & col size
  # $a2 & matrix
  func_create_matrix:
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

    li $v0, 4
    la $a0, s_ask_size
    syscall

    li $v0, 5
    syscall
    move $s3, $v0
    sw $s3, ($s0)

    li $v0, 5
    syscall
    move $s4, $v0
    sw $s4, ($s1)

    li $t0, 4
    mul $a0, $s3, $s4
    mul $a0, $a0, $t1
    li $v0, 9
    syscall
    sw $v0, ($s2)

    jr $ra

  # $a0 row size
  # $a1 col size
  # $a2 pointer to the matrix
  func_read_matrix:
    move $s1, $a2 # Pointer to the matrix

    li $t1, 4
    mul $s0, $a0, $a1 # Amount of matrix enteries
    mul $s0, $s0, $t1
    add $s2, $s1, $s0 # Matrix's end pointer

    li $v0, 4
    la $a0, s_ask_matrix
    syscall

    loop_read_matrix_foreach:
      li $v0, 5
      syscall

      sw $v0, ($s1)

      addi $s1, $s1, 4
      bne $s1, $s2, loop_read_matrix_foreach

    jr $ra

  # $a0 row size
  # $a1 col size
  # $a2 pointer to the matrix
  func_print_matrix:
    move $s0, $a1 # Matrix col size
    move $s1, $a2 # Pointer to the matrix

    li $t1, 4
    mul $t0, $a0, $a1
    mul $t0, $t0, $t1
    add $s2, $s1, $t0 # End ptr

    li $v0, 4
    la $a0, s_printing_matrix
    syscall

    li $t0, 0 # Endl counter
    loop_print_matrix:
      li $v0, 1
      lw $a0, ($s1)
      syscall

      # Make space or endl
      addi $t0, $t0, 1
      bne $t0, $s0, unless_print_matrix_endl
        li $t0, 0
        la $a0, s_endl
        j endif_print_matrix
      unless_print_matrix_endl:
        la $a0, s_space
      endif_print_matrix:

      li $v0, 4
      syscall

      # Finish loop
      addi $s1, $s1, 4
      bne $s1, $s2, loop_print_matrix

    jr $ra

  # @ $a0 row
  # @ $a1 col
  # @ $v0 &node
  func_matrix_node:
    lw $v0, ptr_selected
    lw $s0, int_selected_col

    # Select row
    mul $t0, $s0, $a0

    # Select col
    add $t0, $t0, $a1

    # word -> byte
    li $t1, 4
    mul $t0, $t0, $t1

    # arr + n
    add $v0, $v0, $t0

    jr $ra

  func_mul:
    sw $ra, reg_mul_ra

    # Check if multiplication is possible
    lw $t0, int_matrix_a_col
    lw $t1, int_matrix_b_row
    beq $t0, $t1, endif_mul_size # if a_col != b_row
      li $v0, 4
      la $a0, s_bad_matrix_size
      syscall

      li $v0, 10
      syscall
    endif_mul_size:

    li $v0, 4
    la $a0, s_mult
    syscall

    # Set C size
    lw $t0, int_matrix_a_row
    lw $t1, int_matrix_b_col

    sw $t0, int_matrix_c_col
    sw $t1, int_matrix_c_row

    # Alloc memory
    li $t2, 4
    mul $a0, $t0, $t1
    mul $a0, $a0, $t2
    li $v0, 9
    syscall
    sw $v0, ptr_matrix_c

    sw $zero, int_for_row
    for_mul_row:

      sw $zero, int_for_col
      for_mul_col:
        sw $zero, int_accu

        sw $zero, int_for_key
        for_mul_node:
          # Select A
          lw $t0, int_matrix_a_col
          sw $t0, int_selected_col
          lw $t0, ptr_matrix_a
          sw $t0, ptr_selected
          lw $a0, int_for_row
          lw $a1, int_for_key
          jal func_matrix_node

          lw $t0, ($v0)
          sw $t0, int_a

          # Select B
          lw $t0, int_matrix_b_col
          sw $t0, int_selected_col
          lw $t0, ptr_matrix_b
          sw $t0, ptr_selected
          lw $a0, int_for_key
          lw $a1, int_for_col
          jal func_matrix_node

          lw $t0, int_a
          lw $t1, ($v0)
          mul $t1, $t0, $t1

          lw $t0, int_accu
          add $t0, $t0, $t1
          sw $t0, int_accu

          lw $t0, int_for_key
          addi $t0, $t0, 1
          sw $t0, int_for_key
          lw $t1, int_matrix_a_col
          ble $t0, $t1, for_mul_node


        # Select C
        lw $t0, int_matrix_c_col
        sw $t0, int_selected_col
        lw $t0, ptr_matrix_c
        sw $t0, ptr_selected
        lw $a0, int_for_row
        lw $a1, int_for_col
        jal func_matrix_node

        lw $t0, int_accu
        sw $t0, ($v0)

        lw $t0, int_for_col
        addi $t0, $t0, 1
        sw $t0, int_for_col
        lw $t1, int_matrix_c_col
        ble $t0, $t1 for_mul_col

      lw $t0, int_for_row
      addi $t0, $t0, 1
      sw $t0, int_for_row
      lw $t1, int_matrix_c_row
      ble $t0, $t1, for_mul_row


    lw $ra, reg_mul_ra
    jr $ra
