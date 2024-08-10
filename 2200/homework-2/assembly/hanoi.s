!============================================================
! CS 2200 Homework 2 Part 2: Tower of Hanoi
!
! Apart from initializing the stack,
! please do not edit mains functionality. You do not need to
! save the return address before jumping to hanoi in
! main.
!============================================================
!int minimumHanoi(int n) {
!     if (n == 1)
!        return 1; 
!     else
!        return (2 * minimumHanoi(n - 1)) + 1; }

main:
                                    ! TODO: Here, you need to get the address of the stack
    lea $sp, stack                  ! using the provided label to initialize the stack pointer.
                                   ! load the label address into $sp and in the next instruction,
    lw      $sp, 0($sp)             ! use $sp as base register to load the value (0xFFFF) into $sp.
    lea     $at, hanoi              ! loads address of hanoi label into $at
    lea     $a0, testNumDisks6      ! loads address of number into $a0
    lw      $a0, 0($a0)             ! loads value of number into $a0
    jalr    $at, $ra                ! jump to hanoi, set $ra to return addr
    halt                            ! when we return, just halt

hanoi:
    
    !addi $sp, $sp, -1               ! TODO: perform post-call portion of       
    sw $fp, 0($sp)                   ! the calling convention. Make sure to
    addi $fp, $sp, 0                ! save any registers you will be using!

                                     ! TODO: Implement the following pseudocode in assembly:
                                       ! IF ($a0 == 1)
    beq $a0, $zero, base               !    GOTO base
    beq $a0, $a0, else               ! ELSE
                                    !    GOTO else
else:
                                    ! TODO: perform recursion after decrementing
    addi $a0, $a0, -1               ! the parameter by 1. Remember, $a0 holds the
    addi $sp, $sp, -1
    sw $ra, 0($sp)
    lea $t1, hanoi
    addi $sp, $sp, -1
    jalr $t1, $ra                   ! parameter value.

                                    ! TODO: Implement the following pseudocode in assembly:
    addi $t1,  $zero, 1             ! $v0 = 2 * $v0 + 1 
    sll $v0, $v0, $t1 
    addi $v0,$v0,1                  ! RETURN $v0
    beq $zero, $zero, teardown
base:
    addi $v0, $zero, 1              ! TODO: Return 1
    beq $zero, $zero, teardown
teardown:
    add $sp, $fp, $zero
    lw $fp, 0($sp)
    addi $sp, $sp, 1                ! TODO: perform pre-return portion
    lw $ra, 0($sp)
    addi $sp, $sp, 1                                 ! of the calling convention
    jalr    $ra, $zero              ! return to caller



stack: .word 0xFFFF                 ! the stack begins here


! Words for testing \/

! 1
testNumDisks1:
    .word 0x0001

! 3
testNumDisks6:
.word 0x0003

! 10
testNumDisks2:
    .word 0x000a

! 20
testNumDisks3:
    .word 0x0014
