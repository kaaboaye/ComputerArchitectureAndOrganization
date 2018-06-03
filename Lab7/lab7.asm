.data
  sAskA: .asciiz "A: "
  sAskB: .asciiz "B: "
  sAskC: .asciiz "C: "
  sAskD: .asciiz "D: "
  sResult: .asciiz "Result: "
  sEndl: .asciiz "\n"

  # $s0 is an accumulator

  # Operation (a + b) - (c - d)
  # Equivalent a + b - c + d

.text
  .globl main
  main:
    # Read A value
    la $a0, sAskA
    jal read
    # Set accumulator to A
    move $s0, $v0


    # Read B value
    la $a0, sAskB
    jal read
    # Accu + B
    add $s0, $s0, $v0


    # Read C value
    la $a0, sAskC
    jal read
    # Accu - C
    sub $s0, $s0, $v0

    # Read D value
    la $a0, sAskD
    jal read
    # Accu + D
    add $s0, $s0, $v0

    # Print result
    li $v0, 4
    la $a0, sResult
    syscall # Print "Result: "

    li $v0, 1
    move $a0, $s0
    syscall # Print result: $s0

    li $v0, 4
    la $a0, sEndl
    syscall # Print endl

    li $v0, 10
    syscall # exit


  read:
    li $v0, 4
    # $a0 is an argument
    syscall # Ask for A value

    li $v0, 5
    syscall # Read input

    jr $ra # Return
