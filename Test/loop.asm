.text

.globl main
main: 
 li $t1, 3 # int i
 li $t0, 0 # int val
 
 li $v0, 4
 la $a0, ansIs
 syscall # print "ans = "
 
 li $v0, 1
 move $a0, $t0
 syscall # print val
 
 li $v0, 4
 la $a0, endl
 syscall # print endl

 do:
  add $t0, $t0, $t1 # val += i
 
  li $v0, 1
  move $a0, $t1
  syscall # print i
 
  li $v0, 4
  la $a0, s2pl2eq
  syscall # print " + ans = "
 
  li $v0, 1
  move $a0, $t0
  syscall # print val
 
  li $v0, 4
  la $a0, endl
  syscall # print endl
  
  addi $t1, $t1, -1
  bnez $t1, do # while(i)
 
 li $v0, 10
 syscall # exit
 
 
.data
 ansIs: .asciiz "ans = "
 s2pl2eq: .asciiz " + ans = "
 endl: .asciiz "\n"