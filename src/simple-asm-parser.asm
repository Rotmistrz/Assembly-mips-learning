.data
    line: .space 32
    correctMessage: .asciiz "The word is a correct assembly command\n"
    errorMessage: .asciiz "The word isn't a correct assembly command\n"
    beginMessage: .asciiz "Give number of instructions (1 to 5):\n"
    wrongSizeMessage: .asciiz "Number of commands must be in <0; 5>\n"
    spaceNumber: .word 32 # space
    newlineNumber: .word 10 # new line
    space: .asciiz " "
    newline: .asciiz "\n"

    lineCounter: .word 0
    maxSize: .word 0
    commandsAmount: .word 0

    # asm instructions
    iADD: .asciiz "ADD "
    iADDI: .asciiz "ADDI "
    iJ: .asciiz "J "
    iNOOP: .asciiz "NOOP"
    iMULT: .asciiz "MULT "
    iJR: .asciiz "JR "
    iJAL: .asciiz "JAL "
    
    itmp: .space 32
.text
    main:
    li $t0 0
    sw $t0 maxSize
    
    li $v0 4
    la $a0 beginMessage
    syscall
    
    li $v0 5
    syscall
    
    sw $v0 maxSize
    
    jal checkGivenSize
    
    begin:
    li $s0 0 # input counter of a function
    li $s1 0 # instructions counter
    
    li $t0 0 # tmp for byte
    li $t1 0 # tmp for byte
    li $t2 0 # tmp fot byte
    li $t3 0 # counter of pattern
    li $t4 0 # counter of word
    li $t5 0 # output result of a function
    li $t6 0 # result of boolean greater/less than
    li $t7 0 # instructions counter

    lw $t0 lineCounter
    lw $t1 maxSize
    
    slt $t6 $t0 $t1
    bne $t6 1 show

    jal readLine
    
    try:
    
    beq $t7 0 isAdd
    beq $t7 1 isAddi
    beq $t7 2 isJ
    beq $t7 3 isNoop
    beq $t7 4 isJal
    beq $t7 5 isJr
    
    b false

    endOfComparison:
    beq $t5 1 true
    
    again:
    addi $t7 $t7 1
    b try
    
    false:
    la $a0 errorMessage
    li $v0 4
    syscall
    
    b begin
    
    true:
    la $a0 correctMessage
    li $v0 4
    syscall
    
    lw $t0 lineCounter
    addi $t0 $t0 1
    sw $t0 lineCounter
    
    jal saveLine
    
    b begin
    
    show:
    
    jal showStack
    
    exit:
    
    li $v0, 10
    syscall
    
    readLine:
        li $v0 8
        la $a0 line
        li $a1 32 
        syscall
    
    	jr $ra
    
    isRegister:
        li $t5 1
        
        # checking if first character is $
        lb $t0 line($t4)
        bne $t0, 36, ENDisRegisterWithError
        
        addi $t4 $t4 1
        
        # checking if first digit is in <0; 3>
        lb $t0 line($t4)
        slti $t6, $t0, 48
        beq $t6, 1, ENDisRegisterWithError
        
        sgt $t6, $t0, 51
        beq $t6, 1, ENDisRegisterWithError
        
        addi $t4 $t4 1
        
        # checking if it is the end of word
        lb $t0 line($t4)
        lw $t1 spaceNumber
        beq $t0, $t1, ENDisRegister
        
        lw $t1 newlineNumber
        beq $t0, $t1, ENDisRegister
        
        # checking if second digit is in <0; 9>
        lb $t0 line($t4)
        slti $t6 $t0 48
        beq $t6, 1, ENDisRegisterWithError
        
        sgt $t6 $t0 57
        beq $t6, 1, ENDisRegisterWithError
        
        b ENDisRegister
        
        ENDisRegisterWithError:
        li $t5 0
        
        ENDisRegister:
        jr $ra
        
    isLabel:
        li $t5 1
        
        isLabelLoop:
        
        lb $t0 line($t4)
        
        # checking if it is the end of word
        lw $t1 spaceNumber
        beq $t0, $t1, ENDisLabel
        
        lw $t1 newlineNumber
        beq $t0, $t1, ENDisLabel
        
        # checking if following character is a letter
        slti $t6, $t0, 97
        beq $t6, 1, ENDisLabelWithError
        
        sgt $t6, $t0, 122
        beq $t6, 1, ENDisLabelWithError
        
        addi $t4, $t4, 1
        b isLabelLoop
        
        ENDisLabelWithError:
        li $t5 0
        
        ENDisLabel:
        jr $ra
    
    isInteger:
        li $t5 1
        
        # checking if following character is a digit
        lb $t0 line($t4)
        
        slti $t6, $t0, 48
        beq $t6, 1, ENDisIntegerWithError
        
        sgt $t6, $t0, 57
        beq $t6, 1, ENDisIntegerWithError
        
        addi $t4 $t4 1
        
        # loop
        isIntegerLoop:
        
        lb $t0 line($t4)
        
        # checking if it is the end of word
        lw $t1 spaceNumber
        beq $t0, $t1, ENDisInteger
        
        lw $t1 newlineNumber
        beq $t0, $t1, ENDisInteger
        
        # checking if following character is a digit
        slti $t6, $t0, 48
        beq $t6, 1, ENDisIntegerWithError
        
        sgt $t6, $t0, 57
        beq $t6, 1, ENDisIntegerWithError
        
        addi $t4, $t4, 1
        b isIntegerLoop
        
        ENDisIntegerWithError:
        li $t5 0
        
        ENDisInteger:
        jr $ra
        
    ##### ADDI #####  
    isAddi:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isAddiLoop:
        lb $t0 line($t4)
        lb $t1 iADDI($t3)
        
        bne $t0 $t1 ENDisAddiWithError
        
        beq $t4 4 addiFirstRegister
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isAddiLoop
    
        addiFirstRegister:
	addi $t4 $t4 1
	
        jal isRegister
        
        bne $t5 1 ENDisAddiWithError
        
        # Cheking if comma
        addi $t4 $t4 1
        lb $t0 line($t4)
        
        bne $t0 44 ENDisAddiWithError
        
        # Cheking if space
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 spaceNumber
        
        bne $t0 $t2 ENDisAddiWithError
        
        # Cheking if second register
        addi $t4 $t4 1
        
        jal isRegister
        
        bne $t5 1 ENDisAddiWithError
        
        # Cheking if comma
        addi $t4 $t4 1
        lb $t0 line($t4)
        
        bne $t0 44 ENDisAddiWithError
        
        # Cheking if space
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 spaceNumber
        
        bne $t0 $t2 ENDisAddiWithError
        
        # Checking if integer
        addi $t4 $t4 1
        jal isInteger
        
        bne $t5 1 ENDisAddiWithError
        b ENDisAddi
        
        ENDisAddiWithError:
        li $t5 0
    
        ENDisAddi:
        b endOfComparison
       
        
    ##### ADD #####
    isAdd:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isAddLoop:
        lb $t0 line($t4)
        lb $t1 iADD($t3)
        
        bne $t0 $t1 ENDisAddWithError
        
        beq $t4 3 addFirstRegister
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isAddLoop
    
        addFirstRegister:
	addi $t4 $t4 1
	
        jal isRegister
        
        bne $t5 1 ENDisAddWithError
        
        # Checking if comma
        addi $t4 $t4 1
        lb $t0 line($t4)
        
        bne $t0 44 ENDisAddWithError
        
        # Checking if space
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 spaceNumber
        
        bne $t0 $t2 ENDisAddWithError
        
        # Checking if second register
        addi $t4 $t4 1
        
        jal isRegister
        
        bne $t5 1 ENDisAddWithError
        
        # Checking if comma
        addi $t4 $t4 1
        lb $t0 line($t4)
        
        bne $t0 44 ENDisAddWithError
        
        # Checking if space
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 spaceNumber
        
        bne $t0 $t2 ENDisAddWithError
        
        # Checking if third register
        addi $t4 $t4 1
        
        jal isRegister
        
        bne $t5 1 ENDisAddWithError
        
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 newlineNumber

        bne $t0 $t2 ENDisAddWithError
                        
        b ENDisAdd
        
        ENDisAddWithError:
        li $t5 0
    
        ENDisAdd:
        b endOfComparison
    
    ##### JR #####
    isJr:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isJrLoop:
        lb $t0 line($t4)
        lb $t1 iJR($t3)
        
        bne $t0 $t1 ENDisJrWithError
        
        beq $t4 2 jrRegister
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isJrLoop
    
        jrRegister:
	addi $t4 $t4 1
	
        jal isRegister
        
        bne $t5 1 ENDisJrWithError
        
        addi $t4 $t4 1
        lb $t0 line($t4)
        lw $t2 newlineNumber

        bne $t0 $t2 ENDisJrWithError
                        
        b ENDisJr
        
        ENDisJrWithError:
        li $t5 0
    
        ENDisJr:
        b endOfComparison
    
    ##### J #####
    isJ:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isJLoop:
        lb $t0 line($t4)
        lb $t1 iJ($t3)
        
        bne $t0 $t1 ENDisJWithError
        
        beq $t4 1 jLabel
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isJLoop
    
        jLabel:
	addi $t4 $t4 1
	
        jal isLabel
        
        bne $t5 1 ENDisJWithError
        
        lb $t0 line($t4)
        
        bne $t0 10 ENDisJWithError
                    
        b ENDisJ
        
        ENDisJWithError:
        li $t5 0
    
        ENDisJ:
        b endOfComparison
    
    ##### JAL #####
    isJal:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isJalLoop:
        lb $t0 line($t4)
        lb $t1 iJAL($t3)
        
        bne $t0 $t1 ENDisJalWithError
        
        beq $t4 3 jalLabel
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isJalLoop
    
        jalLabel:
	addi $t4 $t4 1
	
        jal isLabel
        
        bne $t5 1 ENDisJalWithError
        
        lb $t0 line($t4)
        
        bne $t0 10 ENDisJalWithError
                    
        b ENDisJal
        
        ENDisJalWithError:
        li $t5 0
    
        ENDisJal:
        b endOfComparison
    
    ##### NOOP #####
    isNoop:
        li $t5 1
    
        li $t3 0 # pattern
        li $t4 0 # word
    
        isNoopLoop:
        lb $t0 line($t4)
        lb $t1 iNOOP($t3)
        
        bne $t0 $t1 ENDisNoopWithError
        
        beq $t4 3 noopNewLine
    
        addi $t3 $t3 1
        addi $t4 $t4 1
        b isNoopLoop
    
        noopNewLine:
	addi $t4 $t4 1
        lb $t0 line($t4)
        
        bne $t0 10 ENDisNoopWithError
                        
        b ENDisNoop
        
        ENDisNoopWithError:
        li $t5 0
    
        ENDisNoop:
        b endOfComparison
        
    saveLine:
        li $t0 0
        li $t2 0
        addi $sp $sp -32
        
        saveLineLoop:
        lb $t1 line($t0)
        sb $t1 0($sp)
        addi $t2 $t2 1
        addi $t0 $t0 1
        addi $sp $sp 1
    
        bne $t1 10 saveLineLoop
       
        sub $sp $sp $t2
    jr $ra
    
    showStack:
        li $t0 0
        
        showStackLoop:
        lw $t1 maxSize
    
        move $a0, $sp
        li $v0 4
        syscall
        
        addi $t0 $t0 1
    
        beq $t0 $t1 exitShowStack
        
        addi $sp $sp 32
        b showStackLoop
    exitShowStack:
    jr $ra
    
    checkGivenSize:
        lw $t0 maxSize
        
        #li $v0 1
        #move $a0 $t0
        #syscall
        
        slti $t6, $t0, 1
        beq $t6 1 givenSizeError
        
        sgt $t6, $t0, 5
        beq $t6 1 givenSizeError
    
        b givenSizeCorrect
    
        givenSizeError:
        li $v0 4
        la $a0 wrongSizeMessage
        syscall
        
        b main
        
        givenSizeCorrect:
    jr $ra
