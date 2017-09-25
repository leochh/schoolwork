# cord = [int(i) for i in input("Point:").strip().split(',')]
# init_gameboard = [[0,0,0],
#                   [0,0,0],
#                   [0,0,0]]
#
def writeBoard(gameboard):
    gameGraph = []
    for i in range(3):
        _line = ""
        for j in range(3):
            if gameboard[i][j] == 0:
                _line += "_"
            elif gameboard[i][j] == 1:
                _line += "X"
            elif gameboard[i][j] == -1:
                _line += "O"
        gameGraph.append(_line)
    return gameGraph

def readBoard(input_line):
    line = list(input_line)
    for n,i in enumerate(line):
        if i == "_":
            line[n] = 0
        elif i == "X":
            line[n] = 1
        elif i == "O":
            line[n] = -1
    return line


player = input()
currentBoard = [readBoard(input().strip()) for i in range(3)]


def strategyAnalysis(_currentBoard, _currentPlayer, _depth):

    def evalCurrentBoard(_cB):

        def evalLine(p1,p2,p3):
            scores = 0
            if p1 == 0 and p2 == 0 and p3 == 0: # Empty line [0,0,0] is 5 scores cost
                # if _currentPlayer == "X":
                #     scores = -5
                # elif _currentPlayer == "O":
                #     scores = 5
                scores = 0
            # elif p1+p2+p3 == 0: # Line with both players' pieces Ep. [1,-1,0]
            #     scores = 0
            elif p1+p2+p3 == 3:
                scores = 1000
            elif p1+p2+p3 == 2:
                scores = 200
            elif p1+p2+p3 == 1:
                if abs(p1)+abs(p2)+abs(p3) == 1:
                    scores = 50
                elif abs(p1)+abs(p2)+abs(p3) == 3:
                    scores = 0
            elif p1+p2+p3 == -3:
                scores = -1000
            elif p1+p2+p3 == -2:
                scores = -200
            elif p1+p2+p3 == -1:
                if abs(p1)+abs(p2)+abs(p3) == 1:
                    scores = -50
                elif abs(p1)+abs(p2)+abs(p3) == 3:
                    scores = 0
            return scores

        line_score = 0
        for r in range(3):
            line_score += evalLine(_cB[r][0],_cB[r][1],_cB[r][2])
        for c in range(3):
            line_score += evalLine(_cB[0][c],_cB[1][c],_cB[2][c])
        line_score += evalLine(_cB[0][0],_cB[1][1],_cB[2][2],)
        line_score += evalLine(_cB[2][0],_cB[1][1],_cB[0][2],)
        return line_score

    def generateNewBoard(step):
        tempBoard = [row[:] for row in _currentBoard]
        if _currentPlayer == "X":
            tempBoard[step[0]][step[1]] = 1
        elif _currentPlayer == "O":
            tempBoard[step[0]][step[1]] = -1
        return tempBoard

    nextPossibleMoves = []
    for r in range(3):
        for c in range(3):
            if _currentBoard[r][c] == 0:
                nextPossibleMoves.append([r,c])

    optimized_move = None
    if _currentPlayer == "X":
        optimized_scores = -1000
    elif _currentPlayer == "O":
        optimized_scores = 1000

    if nextPossibleMoves == [] or _depth == -1:
        return [[],0]
    else:
        for step_move in nextPossibleMoves:
            newBoard = generateNewBoard(step_move)
            single_step_move_scores = evalCurrentBoard(newBoard)

            print(newBoard)
            print(single_step_move_scores)
            if _currentPlayer == "X":
                total_step_move_scores = single_step_move_scores + \
                                         strategyAnalysis(newBoard, "O", _depth - 1)[1]
                if total_step_move_scores > optimized_scores:
                    optimized_scores = total_step_move_scores
                    optimized_move = step_move
            elif _currentPlayer == "O":
                total_step_move_scores = single_step_move_scores + \
                                         strategyAnalysis(newBoard, "X", _depth - 1)[1]
                if total_step_move_scores < optimized_scores:
                    optimized_scores = total_step_move_scores
                    optimized_move = step_move

        return [optimized_move,optimized_scores]

def play(_cBoard,_cPlayer,_turns):
    print("Turn {}".format(_turns))
    nextStrategy = strategyAnalysis(_cBoard, _cPlayer, 1)
    nextStep = nextStrategy[0]
    print(nextStrategy)
    if nextStep:
        if _cPlayer == "X":
            _cBoard[nextStep[0]][nextStep[1]] = 1
        elif _cPlayer == "O":
            _cBoard[nextStep[0]][nextStep[1]] = -1

        for i in writeBoard(_cBoard):
            print(i)

        if _cPlayer == "X":
            _cPlayer = "O"
        else:
            _cPlayer = "X"
        return play(_cBoard, _cPlayer,_turns+1)
    else:
        return print("Game Over!")

play(currentBoard,player,1)
