import Foundation

struct Day21 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day21", ofType: "txt")!)
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
     
     
        var positionPlayer1 = Int(input.first!.suffix(2).filter { $0.isNumber } )!
        var positionPlayer2 = Int(input.last!.suffix(2).filter { $0.isNumber })!
        
        
        // MARK: - Puzzle 1
        
        let boardLength = 10
        
        var scorePlayer1 = 0
        var scorePlayer2 = 0
        
        let winningScore = 1_000
        
        let dice = 1 ... 100
        var currentIndexInDice = dice.startIndex
        
        var isTurnOfPlayer1 = true
        
        var diceRolls = 0
        
        while scorePlayer1 < winningScore && scorePlayer2 < winningScore {
            
            var moveForward = dice[currentIndexInDice]
            currentIndexInDice = dice.index(after: currentIndexInDice)
            if currentIndexInDice >= dice.endIndex {
                currentIndexInDice = dice.startIndex
            }
            moveForward += dice[currentIndexInDice]
            currentIndexInDice = dice.index(after: currentIndexInDice)
            if currentIndexInDice >= dice.endIndex {
                currentIndexInDice = dice.startIndex
            }
            moveForward += dice[currentIndexInDice]
            currentIndexInDice = dice.index(after: currentIndexInDice)
            if currentIndexInDice >= dice.endIndex {
                currentIndexInDice = dice.startIndex
            }
            
            diceRolls += 3
            
            if isTurnOfPlayer1 {
                let step = (positionPlayer1 + moveForward) % ( boardLength)
                positionPlayer1 = step == 0 ? 10 : step
                
                scorePlayer1 += positionPlayer1
            } else {
                let step = (positionPlayer2 + moveForward) % ( boardLength)
                positionPlayer2 = step == 0 ? 10 : step
                
                scorePlayer2 += positionPlayer2
            }
            
            isTurnOfPlayer1.toggle()
        }
        
        
        if scorePlayer1 >= winningScore {
            print("Player 1 won the game.")
            print("Loosing player has a score of \(scorePlayer2)")
            print("Dice rolled \(diceRolls) times")
            print("Result of \(scorePlayer2) * \(diceRolls) = \(scorePlayer2 * diceRolls)")
        } else {
            print("Player 2 won the game.")
            print("Loosing player has a score of \(scorePlayer1)")
            print("Dice rolled \(diceRolls) times")
            print("Result of \(scorePlayer1) * \(diceRolls) = \(scorePlayer1 * diceRolls)")
        }
        
        
        // MARK: - Puzzle 2
        
    }
}
