.data
  vec_len: .word 0
  vec1ord: .word 0
  vec1val: .word 0
  vec2ord: .word 0
  vec2val: .word 0

  s_space: .asciiz " "
  s_endl: .asciiz "\n"
  s_size_of_vector: .asciiz "Provide size of a vector: "
  s_provide_vector1: .asciiz "Provide vector 1\n"
  s_provide_vector2: .asciiz "Provide vector 2\n"
  s_vector1: .asciiz "Vector 1: "
  s_vector2: .asciiz "Vector 2: "
  s_dot_product: .asciiz "Dot product: "

.text
  .globl main
  main:

  # Prompt and read vector size
  jal read_vector_size

  # Read vector 1
  la $a0, s_provide_vector1
  lw $a1, vec1ord
  lw $a2, vec1val
  jal read_vector

  # Read vector 2
  la $a0, s_provide_vector2
  lw $a1, vec2ord
  lw $a2, vec2val
  jal read_vector

  # Print vector 1
  la $a0, s_vector1
  lw $a1, vec1ord
  lw $a2, vec1val
  jal print_vector

  # Print vector 2
  la $a0, s_vector2
  lw $a1, vec2ord
  lw $a2, vec2val
  jal print_vector

  # Calc and print dot product
  jal dot_product

  li $v0, 10
  syscall #exit

  # ##
  # Functions
  # ##

  # void read_vector_size()
  # @ Reads vector size and sets up memory
  #
  # $t0 int vec_len
  read_vector_size:
    li $v0, 4
    la $a0, s_size_of_vector
    syscall

    li $v0, 5
    syscall # Read size

    move $s0, $v0
    sw $s0, vec_len

    li $v0, 9
    move $a0, $s0
    syscall
    sw $v0, vec1ord

    li $v0, 9
    syscall
    sw $v0, vec2ord

    li $t1, 4
    mul $a0, $s0, $t1

    li $v0, 9
    syscall
    sw $v0, vec1val

    li $v0, 9
    syscall
    sw $v0, vec2val

    jr $ra

  # void read_vector($a0 prompt, $a1 ord, $a2 val)
  # @ Reads vector to the memory
  read_vector:
    lw $s0, vec_len
    li $s1, 4
    move $s3, $a1 # *ord
    move $s4, $a2 # *val

    li $v0, 4
    syscall # Prompt

    # ord end ptr
    add $s5, $s3, $s0

    for_read_vector:
      li $v0, 5
      syscall

      bnez $v0, is_value_read_vector
        sb $v0, ($s3)
        addi $s3, $s3, 1

        bne $s3, $s5, for_read_vector
        jr $ra

      is_value_read_vector:
        li $t0, 1
        sb $t0, ($s3)
        addi $s3, $s3, 1

        sw $v0, ($s4)
        addi $s4, $s4, 4

        bne $s3, $s5, for_read_vector
        jr $ra

  # void print_vector($a0 message, $a1 ord, $a2 val)
  # @ Prints vector
  print_vector:
    lw $s0, vec_len
    move $s1, $a1
    move $s2, $a2
    add $s3, $s1, $s0

    li $v0, 4
    syscall # Print message

    for_print_vector:
      lb $t0, ($s1)
      addi $s1, $s1, 1

      bnez $t0, is_value_print_vector
        li $v0, 1
        move $a0, $t0
        syscall

      j endif_print_vector
      is_value_print_vector:
        lw $a0, ($s2)
        addi $s2, $s2, 4

        li $v0, 1
        syscall

      endif_print_vector:

      li $v0, 4
      la $a0, s_space

      syscall

      bne $s1, $s3, for_print_vector

    li $v0, 4
    la $a0, s_endl
    syscall

    jr $ra

  # void dot_product()
  # @ Calculates and prints dot product of 2 given vectors
  dot_product:
    lw $s0, vec_len
    lw $s1, vec1ord
    lw $s2, vec1val
    lw $s3, vec2ord
    lw $s4, vec2val
    add $s5, $s1, $s0
    li $s6, 0 # Accumulator

    for_dot_product:
      lb $t1, ($s1)
      addi $s1, $s1, 1

      lb $t3, ($s3)
      addi $s3, $s3, 1

      beq $t3, $zero, not_load_v2_dot_product
        lw $t4, ($s4)
        addi $s4, $s4, 4

      not_load_v2_dot_product:

      beq $t1, $zero, is_zero_dot_product
        lw $t2, ($s2)
        addi $s2, $s2, 4

      beq $t3, $zero, is_zero_dot_product
        mul $t6, $t2, $t4

        add $s6, $s6, $t6

      is_zero_dot_product:

      bne $s1, $s5, for_dot_product

    li $v0, 4
    la $a0, s_dot_product
    syscall

    li $v0, 1
    move $a0, $s6
    syscall

    li $v0, 4
    la $a0, s_endl
    syscall

    jr $ra
