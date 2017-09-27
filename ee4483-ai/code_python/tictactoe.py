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


def strategyAnalysis(_currentBoard, _currentPlayer, _depth, previous_aorb):

    def evalCurrentBoard(_cB):

        def evalLine(p1,p2,p3):
            scores = 0
            if p1+p2+p3 == 0:
                scores = 0
            elif p1+p2+p3 == 3:
                scores = 2000
            elif p1+p2+p3 == 2:
                scores = 100
            elif p1+p2+p3 == 1:
                if abs(p1)+abs(p2)+abs(p3) == 1:
                    scores = 10
                elif abs(p1)+abs(p2)+abs(p3) == 3:
                    scores = 0
            elif p1+p2+p3 == -3:
                scores = -2000
            elif p1+p2+p3 == -2:
                scores = -100
            elif p1+p2+p3 == -1:
                if abs(p1)+abs(p2)+abs(p3) == 1:
                    scores = -10
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

    def checkWin():
        if abs(evalCurrentBoard(_currentBoard)) > 1000:
            return True
        else:
            return False

    nextPossibleMoves = []
    for r in range(3):
        for c in range(3):
            if _currentBoard[r][c] == 0:
                nextPossibleMoves.append([r,c])

    if nextPossibleMoves == [] or _depth == -1 or checkWin():
        return [[], evalCurrentBoard(_currentBoard), previous_aorb]
    else:
        optimized_move = None
        if _currentPlayer == "X":
            _alpha = -10000  # Set local alpha for current Max and pass to next Min
            _beta = previous_aorb  # Assign previous Min to current beta
            for current_move in nextPossibleMoves:
                # Only the second returned value is used as the current_move_score
                current_move_score = strategyAnalysis(generateNewBoard(current_move), "O", _depth-1, _alpha)[1]
                if _alpha < current_move_score:
                    _alpha = current_move_score
                    optimized_move = current_move
                    if _alpha > _beta:
                        break
            return [optimized_move, _alpha, _beta]
        elif _currentPlayer == "O":
            _beta = 10000  # Set local beta for current Min and pass to next Max
            _alpha = previous_aorb  # Assign previous Max to current alpha
            for current_move in nextPossibleMoves:
                # Only the second returned value is used as the current_move_score
                current_move_score = strategyAnalysis(generateNewBoard(current_move), "X", _depth-1, _beta)[1]
                if _beta > current_move_score:
                    _beta = current_move_score
                    optimized_move = current_move
                    if _alpha > _beta:
                        break
            return [optimized_move, _beta, _alpha]


def play(_cBoard, _cPlayer, _turns):
    print("Turn {}".format(_turns))
    if _cPlayer == "X":
        nextStrategy = strategyAnalysis(_cBoard, _cPlayer, 2, 10000)
        print(nextStrategy)
        nextStep = nextStrategy[0]
        if nextStep:
            _cBoard[nextStep[0]][nextStep[1]] = 1
            for i in writeBoard(_cBoard):
                print(i)
            return play(_cBoard, "O", _turns+1)
        else:
            return print("Game Over!")
    elif _cPlayer == "O":
        nextStrategy = strategyAnalysis(_cBoard, _cPlayer, 2, -10000)
        print(nextStrategy)
        nextStep = nextStrategy[0]
        if nextStep:
            _cBoard[nextStep[0]][nextStep[1]] = -1
            for i in writeBoard(_cBoard):
                print(i)
            return play(_cBoard, "X", _turns+1)
        else:
            return print("Game Over!")


play(currentBoard,player,1)
