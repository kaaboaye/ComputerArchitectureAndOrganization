.text

.globl main
main:
  li $s0, 0

  loop:
    li $v0, 4
    la $a0, sAsk
    syscall

    li $v0, 5
    syscall # read int

    add $s0, $s0, $v0

    bnez $v0, loop

  li $v0, 4
  la $a0, aSum
  syscall

  li $v0, 1
  move $a0, $s0
  syscall

  li $v0, 4
  la $a0, sEndl
  syscall

  li $v0, 10
  syscall # exit


.data
  sAsk: .asciiz "Enter number: "
  aSum: .asciiz "Sum of provided numbers: "
  sEndl: .asciiz "\n"
