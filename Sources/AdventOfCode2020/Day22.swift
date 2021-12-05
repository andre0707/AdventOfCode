import Foundation

extension Array where Element == Int {
    func winningPlayerScore() -> Int {
        var winningScore = 0
        
        for (index, element) in self.reversed().enumerated() {
            winningScore += (index + 1) * element
        }
        
        return winningScore
    }
}


struct Day22 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day22", ofType: "txt")!).components(separatedBy: "\n\n")
        
        let startDeckPlayer1 = input[0].components(separatedBy: .newlines).compactMap { Int($0) }
        let startDeckPlayer2 = input[1].components(separatedBy: .newlines).compactMap { Int($0) }
        
        
        // MARK: - Task1
        
        var t1_dPlayer1 = startDeckPlayer1
        var t1_dPlayer2 = startDeckPlayer2
        while !t1_dPlayer1.isEmpty && !t1_dPlayer2.isEmpty {
            let cardPlayer1 = t1_dPlayer1.removeFirst()
            let cardPlayer2 = t1_dPlayer2.removeFirst()
            if cardPlayer1 > cardPlayer2 {
                t1_dPlayer1.append(cardPlayer1)
                t1_dPlayer1.append(cardPlayer2)
            } else {
                t1_dPlayer2.append(cardPlayer2)
                t1_dPlayer2.append(cardPlayer1)
            }
        }
        
        print("Task1: Player \(t1_dPlayer1.isEmpty ? 2 : 1) won the game. The winning score is \(t1_dPlayer1.isEmpty ? t1_dPlayer2.winningPlayerScore() : t1_dPlayer1.winningPlayerScore()).") //34324
        
        
        // MARK: - Task2
        
        /// returns winning player with his deck
        func playRecursiveGame(deckPlayer1: [Int], deckPlayer2: [Int]) -> (player: Int, deck: [Int]) {
            var dPlayer1 = deckPlayer1
            var dPlayer2 = deckPlayer2
            
            var previousDecksPlayer1: [[Int]] = []
            var previousDecksPlayer2: [[Int]] = []
            
            while !dPlayer1.isEmpty && !dPlayer2.isEmpty {
                if previousDecksPlayer1.contains(dPlayer1) || previousDecksPlayer2.contains(dPlayer2) {
                    return (player: 1, deck: dPlayer1)
                }
                previousDecksPlayer1.append(dPlayer1)
                previousDecksPlayer2.append(dPlayer2)
                
                let cardPlayer1 = dPlayer1.removeFirst()
                let cardPlayer2 = dPlayer2.removeFirst()
                
                /// check if there needs to be a sub game
                if dPlayer1.count >= cardPlayer1 && dPlayer2.count >= cardPlayer2 {
                    if playRecursiveGame(deckPlayer1: Array(dPlayer1[0 ..< cardPlayer1]), deckPlayer2: Array(dPlayer2[0 ..< cardPlayer2])).player == 1 {
                        dPlayer1.append(cardPlayer1)
                        dPlayer1.append(cardPlayer2)
                    } else {
                        dPlayer2.append(cardPlayer2)
                        dPlayer2.append(cardPlayer1)
                    }
                } else {
                    /// no sub game needed
                    if cardPlayer1 > cardPlayer2 {
                        dPlayer1.append(cardPlayer1)
                        dPlayer1.append(cardPlayer2)
                    } else {
                        dPlayer2.append(cardPlayer2)
                        dPlayer2.append(cardPlayer1)
                    }
                }
            }
            return dPlayer1.isEmpty ? (player: 2, deck: dPlayer2) : (player: 1, deck: dPlayer1)
        }
        
        let winner = playRecursiveGame(deckPlayer1: startDeckPlayer1, deckPlayer2: startDeckPlayer2)
        print("Task2: Player \(winner.player) won the game. The winning score is \(winner.deck.winningPlayerScore()).") //33259
    }
}
