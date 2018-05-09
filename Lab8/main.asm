.data
  sFactorialAsk: .asciiz "Factorial: "
  sResult: .asciiz "Result: "
  endl: .asciiz "\n"

# Registers
# $s0 - user input
# $s1 - factorial value

.text
  .globl main
  main:
    # $v0 = readInt()
    li $v0, 4
    la $a0, sFactorialAsk
    syscall

    li $v0, 5
    syscall

    # $s0 = $v0
    move $s0, $v0

    # $s1 = 1
    li $s1, 1

    # for (; $s0 != 0; --$s0)
    # { $s1 *= $s0 }
    for:
      # $s1 *= $s0
      mul $s1, $s1, $s0

      # --$s0
      addi $s0, $s0, -1

      # if ($s0 != 0)
      # { goto for }
      bnez $s0, for

    # printf("%s%d%s", sResult, $s1, endl)
    li $v0, 4
    la $a0, sResult
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, endl
    syscall

    # exit()
    li $v0, 10
    syscall
    
