# $a0 - reserved for asm
# $a1 - const this

.data
  # struct matrix {
  #   int row; 0()
  #   int col; 4()
  #   int *nodes; 8()
  # }
  matrix_a: .word 0, 0, 0
  matrix_b: .word 0, 0, 0
  matrix_c: .word 0, 0, 0

  s_provide_matrix_size: .asciiz "Provide matrix size. Rows then cols\n"
  s_provide_matrix_nodes: .asciiz "Provide matrix nodes\n"
  s_printing_matrix: .asciiz "Printing matrix\n"
  s_error_wrong_size: .asciiz "Error: Wrong matrix size\n"
  s_space: .asciiz " "
  s_endl: .asciiz "\n"

.text
  .globl main
  main:
    la $a1, matrix_a
    jal new_matrix
    jal read_matrix
    jal print_matrix

    la $a1, matrix_b
    jal new_matrix
    jal read_matrix
    jal print_matrix

    jal mul_matrix

    la $a1, matrix_c
    jal print_matrix

    li $v0, 10
    syscall

  new_matrix:
    li $v0, 4
    la $a0, s_provide_matrix_size
    syscall

    li $v0, 5
    syscall
    move $s0, $v0
    sw $s0, 0($a1)

    li $v0, 5
    syscall
    move $s1, $v0
    sw $s1, 4($a1)

    mul $a0, $s0, $s1
    li $t2, 4
    mul $a0, $a0, $t2
    li $v0, 9
    syscall
    sw $v0, 8($a1)

    jr $ra

  read_matrix:
    li $v0, 4
    la $a0, s_provide_matrix_nodes
    syscall

    lw $s0, 0($a1)
    lw $s1, 4($a1)
    lw $s2, 8($a1)

    mul $t0, $s0, $s1
    li $t1, 4
    mul $t0, $t0, $t1
    add $s3, $s2, $t0

    loop_read_matrix:
      li $v0, 5
      syscall

      sw $v0, ($s2)

      addi $s2, $s2, 4
      bne $s2, $s3, loop_read_matrix

    jr $ra

  print_matrix:
    li $v0, 4
    la $a0, s_printing_matrix
    syscall

    lw $s0, 0($a1)
    lw $s1, 4($a1)
    lw $s2, 8($a1)

    mul $t0, $s0, $s1
    li $t1, 4
    mul $t0, $t0, $t1
    add $s3, $s2, $t0

    li $t0, 0 # endl counter

    loop_print_matrix:
      li $v0, 1
      lw $a0, ($s2)
      syscall

      addi $t0, $t0, 1
      bne $s1, $t0, else_print_matrix
        li $t0, 0
        la $a0, s_endl
      j endif_print_matrix
      else_print_matrix:
        la $a0, s_space
      endif_print_matrix:

      li $v0, 4
      syscall

      addi $s2, $s2, 4
      bne $s2, $s3, loop_print_matrix

    jr $ra

  mul_matrix:
    addi $sp, $sp, -28
    addi $fp, $sp, 8
    # 0  int row
    # 4  int col
    # 8  int node
    # 12 int *current
    # 16 int *tmp

    la $s0, matrix_a
    la $s1, matrix_b
    la $s2, matrix_c

    lw $t0, 4($s0)
    lw $t1, 0($s1)
    beq $t0, $t1, endif_mul_matrix_wrong_size
      li $v0, 4
      la $a0, s_error_wrong_size
      syscall

      li $v0, 10
      syscall
    endif_mul_matrix_wrong_size:

    # Construct matrix_c
    lw $t0, 0($s0)
    sw $t0, 0($s2)
    lw $t1, 4($s1)
    sw $t1, 4($s2)

    mul $a0, $t0, $t1
    li $t0, 4
    mul $a0, $a0, $t0
    li $v0, 9
    syscall
    sw $v0, 8($s2)

    # Fill matrix with 0
    move $t0, $v0
    add $t1, $t0, $a0

    loop_empty_matrix:
      sw $zero, ($t0)

      addi $t0, $t0, 4
      bne $t0, $t1, loop_empty_matrix

    # Multiply
    sw $zero, 0($fp)
    for_mul_row:

      sw $zero, 4($fp)
      for_mul_col:

        sw $ra, 0($sp)
        sw $fp, 4($sp)
        addi $sp, $sp, -12 # args stack
        sw $s2, 0($sp) # *matrix c
        lw $t0, 0($fp) # for row
        sw $t0, 4($sp) # row
        lw $t0, 4($fp) # for col
        sw $t0, 8($sp) # col
        jal node_matrix
        lw $ra, 0($sp)
        lw $fp, 4($sp)
        sw $v0, 12($fp)

        sw $zero, 8($fp)
        for_mul_node:

          sw $ra, 0($sp)
          sw $fp, 4($sp)
          addi $sp, $sp, -12 # args stack
          sw $s0, 0($sp) # *matrix a
          lw $t0, 0($fp) # for row
          sw $t0, 4($sp) # row
          lw $t0, 8($fp) # for node
          sw $t0, 8($sp) # col
          jal node_matrix
          lw $ra, 0($sp)
          lw $fp, 4($sp)
          sw $v0, 16($fp)

          sw $ra, 0($sp)
          sw $fp, 4($sp)
          addi $sp, $sp, -12 # args stack
          sw $s1, 0($sp) # *matrix b
          lw $t0, 8($fp) # for node
          sw $t0, 4($sp) # row
          lw $t0, 4($fp) # for col
          sw $t0, 8($sp) # col
          jal node_matrix
          lw $ra, 0($sp)
          lw $fp, 4($sp)

          lw $t0, 12($fp)
          lw $t1, ($t0)
          lw $t2, 16($fp)
          lw $t2, ($t2)
          move $t3, $v0

          mul $t4, $t2, $t3
          add $t1, $t1, $t4
          sw $t1, ($t0)

          lw $t0, 8($fp)
          addi $t0, $t0, 1
          sw $t0, 8($fp)
          lw $t1, 4($s0)
          bne $t0, $t1, for_mul_node

        lw $t0, 4($fp)
        addi $t0, $t0, 1
        sw $t0, 4($fp)
        lw $t1, 4($s2)
        bne $t0, $t1, for_mul_col


      lw $t0, 0($fp)
      addi $t0, $t0, 1
      sw $t0, 0($fp)
      lw $t1, 0($s2)
      bne $t0, $t1, for_mul_row


    addi $sp, $sp, 28
    jr $ra

  # 0 *matrix
  # 4 row
  # 8 col
  node_matrix:
    lw $t0, 0($sp) # matrix
    lw $t1, 4($sp) # sel row
    lw $t2, 8($sp) # sel col
    addi $sp, $sp, 12

    lw $t3, 4($t0) # mat col
    mul $v0, $t1, $t3
    add $v0, $v0, $t2
    li $t4, 4
    mul $v0, $v0, $t4
    lw $t4, 8($t0)
    add $v0, $v0, $t4

    jr $ra
