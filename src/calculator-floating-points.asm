.data
	a: .word 0
	operation: .word 0
	b: .word 0
	result: .word 0
	remainder: .word 0
	choice: .word 0
	
	c: .double 0.0
	d: .double 0.0
	
	newLine: .asciiz "\n"
	
	firstItemMessage: .asciiz "Put first item\n"
	operationMessage: .asciiz "Put operation code\n"
	secondItemMessage: .asciiz "Put second item\n"
	
	wrongOperationCode: .asciiz "Wrong operation code"
	
	operations: .asciiz "Operations:\n0 - addition\n1 - subtraction\n2 - division\n3 - multiplication\n"
	resultMessage: .asciiz "Result: "
	remainderMessage: .asciiz "Remainder: "
	choiceMessage: .asciiz "Do you want to invoke next operation? (0 - no, 1 - yes)\n"
.text

    main:
    
    li $v0, 4
    la $a0, firstItemMessage
    syscall
    
    jal readDouble
    sdc1 $f0, c
    
    li $v0, 4
    la $a0, operations
    syscall
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, operationMessage
    syscall
    
    jal readInt
    sw $v0, operation
    
    li $v0, 4
    la $a0, secondItemMessage
    syscall
    
    jal readDouble
    sdc1 $f0, d

    lw $t0, operation

    beq $t0, 0, addition
    beq $t0, 1, subtraction
    beq $t0, 2, division
    beq $t0, 3, multiplication
    
    li $v0, 4
    la $a0, wrongOperationCode
    syscall
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    jal main
    
    endif:
    
    sw $t6, remainder
    
    li $v0, 4
    la $a0, resultMessage
    syscall
    
    li $v0, 3
    syscall
   
    # lw $t0, remainder
    # beq $t0, $zero, withoutRemainder
   
    # li $v0, 4
    # la $a0, newLine
    # syscall
    
    # li $v0, 4
    # la $a0, remainderMessage
    # syscall

    # li $v0, 1
    # lw $a0, remainder
    # syscall
    
    withoutRemainder:
    li $v0, 4
    la $a0, newLine
    syscall
    
    li $v0, 4
    la $a0, choiceMessage
    syscall
    
    jal readInt
    sw $v0, choice
    
    lw $t0, choice
    
    li $v0, 4
    la $a0, newLine
    syscall
    
    beq $t0, 1, main
   
    end:
    # end of program
    li $v0, 10
    syscall

    readInt:
    li $v0, 5
    syscall
    jr $ra
    
    readDouble:
    li $v0, 7
    syscall
    jr $ra
    
    addition:
    ldc1 $f2, c
    ldc1 $f4, d
    
    add.d $f12, $f2, $f4
    
    addi $t6, $zero, 0
    
    j endif
    
    subtraction:
    ldc1 $f2, c
    ldc1 $f4, d
    
    sub.d $f12, $f2, $f4
    addi $t6, $zero, 0
    
    j endif
    
    division:
    ldc1 $f2, c
    ldc1 $f4, d
    
    div.d $f12, $f2, $f4
    
    j endif
    
    multiplication:
    ldc1 $f2, c
    ldc1 $f4, d
    
    mul.d $f12, $f2, $f4
    
    addi $t6, $zero, 0
    
    j endif
