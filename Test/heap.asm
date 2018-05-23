.data


.text
  .globl main
  main:
    li $a0, 8
    li $v0, 9
    syscall

    li $t0, 69
    sw $t0, ($v0)
    addi $v0, $v0, 4
    li $t0, 96
    sw $t0, ($v0)

    move $t3, $v0
    addi $v0, $v0, -4

    lw $a0, ($v0)
    li $v0, 1
    syscall

    lw $a0, ($t3)
    li $v0, 1
    syscall

    li $v0, 10
    syscall
