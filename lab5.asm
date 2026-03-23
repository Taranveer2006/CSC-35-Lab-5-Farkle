#------------------------------------------------------------
# Lab 5: Farkle
#------------------------------------------------------------
.intel_syntax noprefix

.data
# ------------------------------------------------------------
# String constants
# ------------------------------------------------------------
WelcomeMsg:    .asciz "Welcome to Farkle: A Push-Your-Luck Game\n"
RollMsg:       .asciz "You rolled: "
Space:         .asciz " "
NewLine:       .asciz "\n"
ScoringHdr:    .asciz "Scoring:\n"
ScoreMsg:      .asciz "Roll score: "
TurnMsg:       .asciz "Turn score so far: "
BankMsg:       .asciz " banked "
PointsMsg:     .asciz " points!\n"
FarkleMsg:     .asciz "FARKLE! You lose all points this turn.\n"
NoScoreMsg:    .asciz " No scoring dice!\n"
ChoiceMsg:     .asciz "Bank (1) or Roll Again (2)? "

# Player strings
P1Label:       .asciz "Player 1"
P2Label:       .asciz "Player 2"
Separator:     .asciz " | "
ColonSpace:    .asciz ": "
TurnPrefix:    .asciz "--- Player "
TurnSuffix:    .asciz "'s Turn ---\n"
WinsMsg:       .asciz " wins with "
WinEnd:        .asciz " points!\n"

# Scoring explanation strings
Triple1Msg:    .asciz " Three 1s = 1000\n"
Triple2Msg:    .asciz " Three 2s = 200\n"
Triple3Msg:    .asciz " Three 3s = 300\n"
Triple4Msg:    .asciz " Three 4s = 400\n"
Triple5Msg:    .asciz " Three 5s = 500\n"
Triple6Msg:    .asciz " Three 6s = 600\n"
SinglePre:     .asciz " "
Single1Mid:    .asciz " single 1(s) = "
Single5Mid:    .asciz " single 5(s) = "

# ------------------------------------------------------------
# Dice values
# ------------------------------------------------------------
die1:          .quad 0
die2:          .quad 0
die3:          .quad 0
die4:          .quad 0
die5:          .quad 0
die6:          .quad 0

# ------------------------------------------------------------
# Face counts
# ------------------------------------------------------------
count1:        .quad 0
count2:        .quad 0
count3:        .quad 0
count4:        .quad 0
count5:        .quad 0
count6:        .quad 0

# ------------------------------------------------------------
# Scores and game state
# ------------------------------------------------------------
roll_score:      .quad 0
turn_score:      .quad 0
score_p1:        .quad 0
score_p2:        .quad 0
current_player:  .quad 0
choice:          .quad 0
temp:            .quad 0

.text
.global Program

# ============================================================
# Program
# ============================================================
Program:
    # Initialize game state
    mov qword ptr [score_p1], 0
    mov qword ptr [score_p2], 0
    mov qword ptr [current_player], 1

    lea rcx, WelcomeMsg
    call PrintStrZ

# ============================================================
# Main game loop
# ============================================================
MainGameLoop:
    # Display scores: Player 1: X | Player 2: Y
    lea rcx, P1Label
    call PrintStrZ
    lea rcx, ColonSpace
    call PrintStrZ
    mov rcx, qword ptr [score_p1]
    call PrintInt64
    lea rcx, Separator
    call PrintStrZ
    lea rcx, P2Label
    call PrintStrZ
    lea rcx, ColonSpace
    call PrintStrZ
    mov rcx, qword ptr [score_p2]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    # Display current turn header
    lea rcx, TurnPrefix
    call PrintStrZ
    mov rcx, qword ptr [current_player]
    call PrintInt64
    lea rcx, TurnSuffix
    call PrintStrZ

    # turn_score = 0
    mov qword ptr [turn_score], 0

# ============================================================
# Turn loop
# ============================================================
TurnLoop:
    # --------------------------------------------------------
    # Roll six dice: random values 1..6
    # --------------------------------------------------------
    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die1], rcx

    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die2], rcx

    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die3], rcx

    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die4], rcx

    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die5], rcx

    mov rcx, 6
    call GetRandom
    add rcx, 1
    mov qword ptr [die6], rcx

    # --------------------------------------------------------
    # Display the roll
    # --------------------------------------------------------
    lea rcx, RollMsg
    call PrintStrZ

    mov rcx, qword ptr [die1]
    call PrintInt64
    lea rcx, Space
    call PrintStrZ

    mov rcx, qword ptr [die2]
    call PrintInt64
    lea rcx, Space
    call PrintStrZ

    mov rcx, qword ptr [die3]
    call PrintInt64
    lea rcx, Space
    call PrintStrZ

    mov rcx, qword ptr [die4]
    call PrintInt64
    lea rcx, Space
    call PrintStrZ

    mov rcx, qword ptr [die5]
    call PrintInt64
    lea rcx, Space
    call PrintStrZ

    mov rcx, qword ptr [die6]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    # --------------------------------------------------------
    # Reset counts
    # --------------------------------------------------------
    mov qword ptr [count1], 0
    mov qword ptr [count2], 0
    mov qword ptr [count3], 0
    mov qword ptr [count4], 0
    mov qword ptr [count5], 0
    mov qword ptr [count6], 0

    # --------------------------------------------------------
    # Count die1
    # --------------------------------------------------------
    mov rax, qword ptr [die1]
    cmp rax, 1
    jne CountDie1_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp CountDie2_Start
CountDie1_Not1:
    cmp rax, 2
    jne CountDie1_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp CountDie2_Start
CountDie1_Not2:
    cmp rax, 3
    jne CountDie1_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp CountDie2_Start
CountDie1_Not3:
    cmp rax, 4
    jne CountDie1_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp CountDie2_Start
CountDie1_Not4:
    cmp rax, 5
    jne CountDie1_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp CountDie2_Start
CountDie1_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

    # --------------------------------------------------------
    # Count die2
    # --------------------------------------------------------
CountDie2_Start:
    mov rax, qword ptr [die2]
    cmp rax, 1
    jne CountDie2_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp CountDie3_Start
CountDie2_Not1:
    cmp rax, 2
    jne CountDie2_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp CountDie3_Start
CountDie2_Not2:
    cmp rax, 3
    jne CountDie2_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp CountDie3_Start
CountDie2_Not3:
    cmp rax, 4
    jne CountDie2_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp CountDie3_Start
CountDie2_Not4:
    cmp rax, 5
    jne CountDie2_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp CountDie3_Start
CountDie2_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

    # --------------------------------------------------------
    # Count die3
    # --------------------------------------------------------
CountDie3_Start:
    mov rax, qword ptr [die3]
    cmp rax, 1
    jne CountDie3_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp CountDie4_Start
CountDie3_Not1:
    cmp rax, 2
    jne CountDie3_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp CountDie4_Start
CountDie3_Not2:
    cmp rax, 3
    jne CountDie3_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp CountDie4_Start
CountDie3_Not3:
    cmp rax, 4
    jne CountDie3_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp CountDie4_Start
CountDie3_Not4:
    cmp rax, 5
    jne CountDie3_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp CountDie4_Start
CountDie3_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

    # --------------------------------------------------------
    # Count die4
    # --------------------------------------------------------
CountDie4_Start:
    mov rax, qword ptr [die4]
    cmp rax, 1
    jne CountDie4_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp CountDie5_Start
CountDie4_Not1:
    cmp rax, 2
    jne CountDie4_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp CountDie5_Start
CountDie4_Not2:
    cmp rax, 3
    jne CountDie4_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp CountDie5_Start
CountDie4_Not3:
    cmp rax, 4
    jne CountDie4_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp CountDie5_Start
CountDie4_Not4:
    cmp rax, 5
    jne CountDie4_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp CountDie5_Start
CountDie4_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

    # --------------------------------------------------------
    # Count die5
    # --------------------------------------------------------
CountDie5_Start:
    mov rax, qword ptr [die5]
    cmp rax, 1
    jne CountDie5_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp CountDie6_Start
CountDie5_Not1:
    cmp rax, 2
    jne CountDie5_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp CountDie6_Start
CountDie5_Not2:
    cmp rax, 3
    jne CountDie5_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp CountDie6_Start
CountDie5_Not3:
    cmp rax, 4
    jne CountDie5_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp CountDie6_Start
CountDie5_Not4:
    cmp rax, 5
    jne CountDie5_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp CountDie6_Start
CountDie5_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

    # --------------------------------------------------------
    # Count die6
    # --------------------------------------------------------
CountDie6_Start:
    mov rax, qword ptr [die6]
    cmp rax, 1
    jne CountDie6_Not1
    mov rbx, qword ptr [count1]
    add rbx, 1
    mov qword ptr [count1], rbx
    jmp ScoreRoll
CountDie6_Not1:
    cmp rax, 2
    jne CountDie6_Not2
    mov rbx, qword ptr [count2]
    add rbx, 1
    mov qword ptr [count2], rbx
    jmp ScoreRoll
CountDie6_Not2:
    cmp rax, 3
    jne CountDie6_Not3
    mov rbx, qword ptr [count3]
    add rbx, 1
    mov qword ptr [count3], rbx
    jmp ScoreRoll
CountDie6_Not3:
    cmp rax, 4
    jne CountDie6_Not4
    mov rbx, qword ptr [count4]
    add rbx, 1
    mov qword ptr [count4], rbx
    jmp ScoreRoll
CountDie6_Not4:
    cmp rax, 5
    jne CountDie6_Not5
    mov rbx, qword ptr [count5]
    add rbx, 1
    mov qword ptr [count5], rbx
    jmp ScoreRoll
CountDie6_Not5:
    mov rbx, qword ptr [count6]
    add rbx, 1
    mov qword ptr [count6], rbx

# ============================================================
# Score roll
# ============================================================
ScoreRoll:
    mov qword ptr [roll_score], 0

    lea rcx, ScoringHdr
    call PrintStrZ

    # Three 1s
    mov rax, qword ptr [count1]
    cmp rax, 3
    jl CheckTriple2
    mov rbx, qword ptr [roll_score]
    add rbx, 1000
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count1], rax
    lea rcx, Triple1Msg
    call PrintStrZ

CheckTriple2:
    mov rax, qword ptr [count2]
    cmp rax, 3
    jl CheckTriple3
    mov rbx, qword ptr [roll_score]
    add rbx, 200
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count2], rax
    lea rcx, Triple2Msg
    call PrintStrZ

CheckTriple3:
    mov rax, qword ptr [count3]
    cmp rax, 3
    jl CheckTriple4
    mov rbx, qword ptr [roll_score]
    add rbx, 300
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count3], rax
    lea rcx, Triple3Msg
    call PrintStrZ

CheckTriple4:
    mov rax, qword ptr [count4]
    cmp rax, 3
    jl CheckTriple5
    mov rbx, qword ptr [roll_score]
    add rbx, 400
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count4], rax
    lea rcx, Triple4Msg
    call PrintStrZ

CheckTriple5:
    mov rax, qword ptr [count5]
    cmp rax, 3
    jl CheckTriple6
    mov rbx, qword ptr [roll_score]
    add rbx, 500
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count5], rax
    lea rcx, Triple5Msg
    call PrintStrZ

CheckTriple6:
    mov rax, qword ptr [count6]
    cmp rax, 3
    jl CheckSingle1
    mov rbx, qword ptr [roll_score]
    add rbx, 600
    mov qword ptr [roll_score], rbx
    sub rax, 3
    mov qword ptr [count6], rax
    lea rcx, Triple6Msg
    call PrintStrZ

    # --------------------------------------------------------
    # Remaining single 1s: count1 * 100
    # --------------------------------------------------------
CheckSingle1:
    mov rax, qword ptr [count1]
    cmp rax, 0
    jle CheckSingle5

    lea rcx, SinglePre
    call PrintStrZ
    mov rcx, qword ptr [count1]
    call PrintInt64
    lea rcx, Single1Mid
    call PrintStrZ

    mov rax, qword ptr [count1]
    imul rax, 100
    mov qword ptr [temp], rax
    mov rcx, qword ptr [temp]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    mov rbx, qword ptr [roll_score]
    add rbx, qword ptr [temp]
    mov qword ptr [roll_score], rbx

    # --------------------------------------------------------
    # Remaining single 5s: count5 * 50
    # --------------------------------------------------------
CheckSingle5:
    mov rax, qword ptr [count5]
    cmp rax, 0
    jle CheckFarkle

    lea rcx, SinglePre
    call PrintStrZ
    mov rcx, qword ptr [count5]
    call PrintInt64
    lea rcx, Single5Mid
    call PrintStrZ

    mov rax, qword ptr [count5]
    imul rax, 50
    mov qword ptr [temp], rax
    mov rcx, qword ptr [temp]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    mov rbx, qword ptr [roll_score]
    add rbx, qword ptr [temp]
    mov qword ptr [roll_score], rbx

# ============================================================
# Check for Farkle / ask player
# ============================================================
CheckFarkle:
    mov rax, qword ptr [roll_score]
    cmp rax, 0
    jne RollScored

    lea rcx, NoScoreMsg
    call PrintStrZ
    lea rcx, FarkleMsg
    call PrintStrZ

    mov qword ptr [turn_score], 0
    mov qword ptr [choice], 1
    jmp EndTurnLoopCheck

RollScored:
    lea rcx, ScoreMsg
    call PrintStrZ
    mov rcx, qword ptr [roll_score]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    mov rax, qword ptr [turn_score]
    add rax, qword ptr [roll_score]
    mov qword ptr [turn_score], rax

    lea rcx, TurnMsg
    call PrintStrZ
    mov rcx, qword ptr [turn_score]
    call PrintInt64
    lea rcx, NewLine
    call PrintStrZ

    lea rcx, ChoiceMsg
    call PrintStrZ
    call ScanInt64
    mov qword ptr [choice], rcx
    lea rcx, NewLine
    call PrintStrZ

EndTurnLoopCheck:
    mov rax, qword ptr [choice]
    cmp rax, 1
    jne TurnLoop

# ============================================================
# End of turn
# ============================================================
EndTurn:
    mov rax, qword ptr [turn_score]
    cmp rax, 0
    jle AddToPlayerTotal

    lea rcx, TurnPrefix
    call PrintStrZ
    mov rcx, qword ptr [current_player]
    call PrintInt64
    lea rcx, BankMsg
    call PrintStrZ
    mov rcx, qword ptr [turn_score]
    call PrintInt64
    lea rcx, PointsMsg
    call PrintStrZ

# ------------------------------------------------------------
# Add turn_score to current player's total
# ------------------------------------------------------------
AddToPlayerTotal:
    mov rax, qword ptr [current_player]
    cmp rax, 1
    jne AddToP2

    mov rbx, qword ptr [score_p1]
    add rbx, qword ptr [turn_score]
    mov qword ptr [score_p1], rbx
    jmp CheckWinP1

AddToP2:
    mov rbx, qword ptr [score_p2]
    add rbx, qword ptr [turn_score]
    mov qword ptr [score_p2], rbx

# ------------------------------------------------------------
# Check for winner
# ------------------------------------------------------------
CheckWinP1:
    mov rax, qword ptr [current_player]
    cmp rax, 1
    jne CheckWinP2

    mov rax, qword ptr [score_p1]
    cmp rax, 10000
    jl SwitchPlayer

    lea rcx, P1Label
    call PrintStrZ
    lea rcx, WinsMsg
    call PrintStrZ
    mov rcx, qword ptr [score_p1]
    call PrintInt64
    lea rcx, WinEnd
    call PrintStrZ
    call ProgramEnd

CheckWinP2:
    mov rax, qword ptr [current_player]
    cmp rax, 2
    jne SwitchPlayer

    mov rax, qword ptr [score_p2]
    cmp rax, 10000
    jl SwitchPlayer

    lea rcx, P2Label
    call PrintStrZ
    lea rcx, WinsMsg
    call PrintStrZ
    mov rcx, qword ptr [score_p2]
    call PrintInt64
    lea rcx, WinEnd
    call PrintStrZ
    call ProgramEnd

# ------------------------------------------------------------
# Switch player
# ------------------------------------------------------------
SwitchPlayer:
    mov rax, qword ptr [current_player]
    cmp rax, 1
    jne SetPlayer1
    mov qword ptr [current_player], 2
    jmp MainGameLoop

SetPlayer1:
    mov qword ptr [current_player], 1
    jmp MainGameLoop
