!============================================================
! CS 2200 Homework 2 Part 1: mod
!
! Edit any part of this file necessary to implement the
! mod operation. Store your result in $v0.
!============================================================

mod:
    addi    $a0, $zero, 28      ! $a0 = 28, the number a to compute mod(a,b)
    addi    $a1, $zero, 13      ! $a1 = 13, the number b to compute mod(a,b)
    add    $t0, $zero, $a0       !int x = a
while:
    bgt    $a1, $t0, return        !while (x >= b) jump to return
    nand   $t1, $a1, $a1  
    addi   $t1, $t1, 1
    add    $t0, $t0, $t1
    beq   $t0, $t0, while
return:
    addi  $v0, $t0, 0
!int mod(int a, int b) { int x = a;
!while (x >= b) {
!x = x - b; }
!return x; }q