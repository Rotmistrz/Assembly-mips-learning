.data
    moves: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # playboard
                                           # 0 - empty, 1 - first player (cross), 2 - second player (circle)
                                           # 0 1 2
                                           # 3 4 5
                                           # 6 7 8
    firstPlayerVictories: .word 0
    secondPlayerVictories: .word 0
    
    # messages
    messagePutFieldNumber: .asciiz "\nPlease put field number\n"
    messageFieldIsOccupied: .asciiz "This field has been occupied yet.\n"
    messageFirstPlayerResult: .asciiz "First player: "
    messageSecondPlayerResult: .asciiz "Computer result: "
    messageFirstWon: .asciiz "First player won!\n"
    messageSecondWon: .asciiz "Computer won!\n"
    
    messageGameOver: .asciiz "\n---End of the game----\n"
    
    newLine: .asciiz "\n"
    circle: .asciiz "O"
    cross: .asciiz "X"
    emptyField: .asciiz "-"
    spaceChar: .asciiz " "
.text

    main:
        beginGame:
    
        li $t0 0
        jal clearBoard
    
        game:
            b getFirstPlayerMove
    
            afterGetFirstPlayerMove:
    
            b checkFirstPlayerWon
            
            afterCheckFirstPlayerWon:
            
            beq $t7 1 firstWon
    
            addi $t0 $t0 1
            beq $t0 5 draw
    
            b getComputerMove
    
            afterGetComputerMove:
        
            b checkSecondPlayerWon
            
            afterCheckSecondPlayerWon:
        
            beq $t7 1 secondWon
        
            jal showGame
        
            b game
    
        firstWon:
            jal showGame
            
            lw $t1 firstPlayerVictories
            addi $t1 $t1 1
            sw $t1 firstPlayerVictories
        
            la $a0 messageFirstWon
            li $v0 4
            syscall
        
            jal showResult
        
            bne $t1 3 beginGame
        
            b endGame
        
        secondWon:
            jal showGame
        
            lw $t1 secondPlayerVictories
            addi $t1 $t1 1
            sw $t1 secondPlayerVictories
        
            la $a0 messageSecondWon
            li $v0 4
            syscall
            
            jal showResult
        
            bne $t1 3 beginGame
            
            b endGame
        draw:
            b beginGame
        
    endGame:
    
    la $a0 messageGameOver
    li $v0 4
    syscall
    
    end:    
    li $v0 10
    syscall
    
    getFirstPlayerMove:
        la $a0 messagePutFieldNumber
        li $v0 4
        syscall
        
        jal readInt
        add $t4 $v0 $zero
        
        jal checkFieldIsFree
        
        beq $t7 1 endGetFirstPlayerMove
        la $a0 messageFieldIsOccupied
        li $v0 4
        syscall
        
        b getFirstPlayerMove
        
        endGetFirstPlayerMove:
        
        mul $t4 $t4 4
        li $t1 1
        sw $t1 moves($t4)
        
    b afterGetFirstPlayerMove
    
    getComputerMove:
        
        # getting random integer 0-8
        li $v0 42
        li $a1 8
        syscall
        
        move $t4 $a0
        
        jal checkFieldIsFree
    
        bne $t7 1 getComputerMove
    
        li $t2 2
        mul $t4 $t4 4
        sw $t2 moves($t4)
    
    b afterGetComputerMove
    
    checkFieldIsFree:
        li $t7 0
        
        add $t5 $t4 $zero
        mul $t5 $t5 4
    
        lw $t1 moves($t5)
        bne $t1 0 fieldNotFree
        li $t7 1
        
        b endCheckFieldIsFree
                
        fieldNotFree:
        li $t7 0
        
        endCheckFieldIsFree:
    jr $ra
    
    checkFirstPlayerWon:
        li $t4 1
        jal checkGameWon
    
    b afterCheckFirstPlayerWon
    
    checkSecondPlayerWon:
        li $t4 2
        jal checkGameWon
    
    b afterCheckSecondPlayerWon
    
    checkGameWon:
        # $t4 - checked value equal to // 1 - first player, 2 - second player
        li $t7 0
        
        firstCheck:
        li $t2 0
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 secondCheck
        
        li $t2 1
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 secondCheck
        
        li $t2 2
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 secondCheck
        
        li $t7 1
        b endCheckGameWon
        
        secondCheck:
        li $t2 3
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 thirdCheck
        
        li $t2 4
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 thirdCheck
        
        li $t2 5
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 thirdCheck
        
        li $t7 1
        b endCheckGameWon
        
        thirdCheck:
        li $t2 6
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fourthCheck
        
        li $t2 7
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fourthCheck
        
        li $t2 8
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fourthCheck
        
        li $t7 1
        b endCheckGameWon
        
        fourthCheck:
        li $t2 0
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fifthCheck
        
        li $t2 3
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fifthCheck
        
        li $t2 6
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 fifthCheck
        
        li $t7 1
        b endCheckGameWon
        
        fifthCheck:
        li $t2 1
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 sixthCheck
        
        li $t2 4
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 sixthCheck
        
        li $t2 7
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 sixthCheck
        
        li $t7 1
        b endCheckGameWon
        
        sixthCheck:
        li $t2 2
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 seventhCheck
        
        li $t2 5
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 seventhCheck
        
        li $t2 8
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 seventhCheck
        
        li $t7 1
        b endCheckGameWon
        
        seventhCheck:
        li $t2 0
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 eighthCheck
        
        li $t2 4
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 eighthCheck
        
        li $t2 8
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 eighthCheck
        
        li $t7 1
        b endCheckGameWon
        
        eighthCheck:
        li $t2 2
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 gameNotWon
        
        li $t2 4
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 gameNotWon
        
        li $t2 6
        mul $t2 $t2 4
        lw $t1 moves($t2)
        bne $t1 $t4 gameNotWon
        
        li $t7 1
        b endCheckGameWon
        
        gameNotWon:
        li $t7 0
        
        endCheckGameWon:
        jr $ra
        
    clearBoard:
        li $t1 0
        li $t2 0
        
        clearBoardLoop:
            add $t3 $t1 $zero
            mul $t3 $t3 4
            
            sw $t2 moves($t3)
            addi $t1 $t1 1
            
            bne $t1 9 clearBoardLoop
        
        endClearBoard:
    
    jr $ra
        
    showResult:
        la $a0 messageFirstPlayerResult
        li $v0 4
        syscall
        
        lw $a0 firstPlayerVictories
        li $v0 1
        syscall
        
        la $a0 newLine
        li $v0 4
        syscall
        
        la $a0 messageSecondPlayerResult
        li $v0 4
        syscall
        
        lw $a0 secondPlayerVictories
        li $v0 1
        syscall
    
    jr $ra
    
    showGame:
        li $t4 0 # main counter
        li $t2 0 # address counter
        li $t5 3 # columns number
    
        showSymbolLoop:
            beq $t4 9 endShowGame # limit of tic-tac-toe board is 9
            
            lw $t1 moves($t2)
            
            beq $t1 0 showEmpty
            beq $t1 1 showCross
            beq $t1 2 showCircle
            
            showEmpty:
                la $a0 emptyField
                li $v0 4
                syscall
               
                b endSymbolShowing
                
            showCross:
                la $a0 cross
                li $v0 4
                syscall
                
                b endSymbolShowing
                
            showCircle:
                la $a0 circle
                li $v0 4
                syscall
                
                b endSymbolShowing
                
            endSymbolShowing:
            
            addi $t4 $t4 1
            addi $t2 $t2 4
            div $t4 $t5
            mfhi $t6
            
            la $a0 spaceChar
            li $v0 4
            syscall
            
            bne $t6 0 showSymbolLoop
           
            la $a0 newLine
            li $v0 4
            syscall
            
            b showSymbolLoop
            
        endShowGame:
        
    jr $ra
    
    readInt:
        li $v0 5
        syscall
    jr $ra
