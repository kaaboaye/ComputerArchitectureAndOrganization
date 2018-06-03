.data
  endl: .asciiz "\n"
  space: .asciiz " "
  s_length: .asciiz "Length: "
  s_provide_array: .asciiz "Provide array bellow\n"

.text
  .globl main
  main:
    # la $s0, arr
    # lw $s1, len
    li $s2, 4 # sizeof(int)

    li $v0, 4
    la $a0, s_length
    syscall

    li $v0, 5
    syscall # Read length

    move $s1, $v0 # Array length

    mul $a0, $s1, $s2 # Memory amount
    li $v0, 9
    syscall # Alloc memory
    move $s0, $v0 # Get pointer

    # Read array
    jal read
    jal print
    jal sort
    jal print

    li $v0, 10
    syscall


  sort: # (int *arr, int len): int -0 $ra
    # $s3 $ra
    #
    # $t0 int tmp
    # $t1 int i = 0
    # $t2 int iEnd = len - 1
    # $t3 int j = 0
    # $t4 int jEnd = iEnd - i
    # $t5 int *ptr
    # $t6 int a // arr[j]
    # $t7 int b // arr[j+1]
    # $t8 swap::int a
    # $t9 swap::int b

    li $t1, 0
    addi $t2, $s1, -1
    forI: # (int i = 0; i < iEnd = len - 1; ++i)

      li $t3, 0
      sub $t4, $t2, $t1
      forJ: # (int j = 0; j < jEnd = iEnd - i; ++j)

        mul $t0, $t3, $s2 # tmp = j * sizeof(int)
        add $t5, $s0, $t0 # ptr = arr + tmp
        lw $t6, ($t5) # a = arr[ptr]

        add $t5, $t5, $s2 # ptr += 1
        lw $t7, ($t5) # b = arr[ptr]

        # if (a > b)
        ble $t6, $t7, else # if (a <= b) goto else
          # swap(*a, *b)
          move $a1, $t5
          sub $a0, $t5, $s2

          addi $sp, $sp, -4
          sw $ra, ($sp)
          jal swap
          lw $ra ($sp)
          addi $sp, $sp, 4
        else:

        addi $t3, $t3, 1
        blt $t3, $t4, forJ

      addi $t1, $t1, 1
      blt $t1, $t2, forI

    jr $ra

  swap: # (int *a, int *b)
    # $t8 int a
    # $t9 int b
    lw $t8, ($a0) # a = *a
    lw $t9, ($a1) # b = *b

    sw $t9, ($a0) # *a = b
    sw $t8, ($a1) # *b = a

    jr $ra

  # Read array
  read:
    move $t0, $s0 # Array pointer

    mul $t1, $s1, $s2 # Memory length
    add $t1, $t0, $t1 # Pointer after array

    li $v0, 4
    la $a0, s_provide_array
    syscall

    forReadArray:
      li $v0, 5
      syscall

      sw $v0, ($t0)
      add $t0, $t0, $s2

      bne $t0, $t1, forReadArray

    jr $ra

  print:
    # $t0 int *arr = arr
    # $t1 int len = len

    move $t0, $s0
    move $t1, $s1

    for:
      lw $a0, ($t0)
      add $t0, $t0, $s2

      li $v0, 1
      syscall

      li $v0, 4
      la $a0, space
      syscall

      addi $t1, $t1, -1
      bnez $t1, for

    li $v0, 4
    la $a0, endl
    syscall

    jr $ra
