import Foundation

struct Day23 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day23", ofType: "txt")!).filter { $0.isNumber }.compactMap { Int(String($0)) }
        
        func playGame(game: [Int], numberOfMoves: Int, printMoves: Bool = false) -> [Int] {
            var game = game
            let gameSize = game.count
            let lowestValue = game.min()!
            let highestValue = game.max()!
            
            var currentCup = game.first!
            var cup1 = 0
            var cup2 = 0
            var cup3 = 0
            for move in 0 ..< numberOfMoves {
                let cupsString = game.map{String($0)}.joined(separator: " ")
                var currentCupIndex = game.firstIndex(where: { $0 == currentCup })!
                let cup1Index = (currentCupIndex + 1) % gameSize
                let cup2Index = (currentCupIndex + 2) % gameSize
                let cup3Index = (currentCupIndex + 3) % gameSize
                cup1 = game[cup1Index]
                cup2 = game[cup2Index]
                cup3 = game[cup3Index]
                
                [cup1Index, cup2Index, cup3Index].sorted().reversed().forEach { game.remove(at: $0) }
                //game.removeAll(where: { [cup1, cup2, cup3].contains($0) })
                
                var destinationCup = currentCup
                repeat {
                    destinationCup = (destinationCup == lowestValue ? highestValue : destinationCup - 1)
                } while [cup1, cup2, cup3].contains(destinationCup)
                let destinationCupIndex = game.firstIndex(where: { $0 == destinationCup })!
                
                if printMoves {
                    print("-- move \(move + 1) --")
                    print("cups: \(cupsString.replacingOccurrences(of: "\(currentCup)", with: "(\(currentCup))"))")
                    print("pick up: \(cup1), \(cup2), \(cup3)")
                    print("destination: \(destinationCup)\n")
                }

                game.insert(contentsOf: [cup1, cup2, cup3], at: ((destinationCupIndex + 1) % gameSize))
                
                currentCupIndex = game.firstIndex(where: { $0 == currentCup })!
                currentCup = game[(currentCupIndex + 1) % gameSize]
            }
            
            while game[0] != 1 {
                game.append(game.removeFirst())
            }
            
            return game
        }
        
        
        /// There is a problem with super high numbers. So what we really need is a circular structure.
        /// Each element in a structure has a neighbor it points to.
        /// Example 1234: 1-> 2, 2->3, 3->4, 4->1
        /// So instead of having the values arranged in the order of pointing to the next one and shift them around, we will use the index as the value and the value for an index is where it points to.
        /// Example from above will then create an array of the length 5 (it is highest number + 1) where we put them in like this [0, 2,3,4,1]
        /// The 0 won't be used (neither would be any other numbers used which don't list up. They all just point to themselves
        /// Another example: 364152 will result in Array: [0, 5, 3, 6, 1, 2, 4]
        func playGameEfficient(with startValues: [Int], moves: Int, printMoves: Bool = false) -> [Int] {
            if startValues.isEmpty { return [] }
            let lowestNumber = startValues.min()!
            let highestNumber = startValues.max()!
            
            /// set up the initial cups array
            var cups = Array<Int>(repeating: 0, count: highestNumber + 1)
            for i in 0 ..< startValues.count {
                let value = ((i + 1) < startValues.count) ? startValues[i + 1] : startValues[0]
                cups[startValues[i]] = value
            }
            
            /// do the crab moves
            var currentCup = startValues[0]
            for move in 0 ..< moves {
                let cup1 = cups[currentCup]
                let cup2 = cups[cup1]
                let cup3 = cups[cup2]
                
                var destinationCup = currentCup
                repeat {
                    destinationCup = (destinationCup == lowestNumber ? highestNumber : destinationCup - 1)
                } while [cup1, cup2, cup3].contains(destinationCup)
                
                if printMoves {
                    var cupsString = ""
                    var i = 1
                    repeat {
                        cupsString += "\(cups[i]) "
                        i = cups[i]
                    } while i != 1
                    print("-- move \(move + 1) --")
                    print("cups: \(cupsString.replacingOccurrences(of: "\(currentCup)", with: "(\(currentCup))"))")
                    print("pick up: \(cup1), \(cup2), \(cup3)")
                    print("destination: \(destinationCup)\n")
                }
                
                cups[currentCup] = cups[cup3] /// removing the 3 next cups after the current cup means: current cup is pointing to the cup which cup3 previous pointed to
                cups[cup3] = cups[destinationCup] /// cup3 is then pointing to whatthe destinationCup pointed to before (cup1 and cup2 do not change. cup1 still points to cup2 and cup2 points still to cup3
                cups[destinationCup] = cup1 /// destionationCup now points to cup1, because cup1 is inserted right next to it
                currentCup = cups[currentCup] /// the next currentCup is where the last currentCup pointed to
            }
            
            return cups
        }
        
        
        
        // MARK: - Task1
        
        let result = playGame(game: input, numberOfMoves: 100)
        print("Task1: Labels on the cups after cup 1: \(result.map{String($0)}.joined(separator: "").dropFirst())") //24798635
        
        let result1 = playGameEfficient(with: input, moves: 100)
        var resultString = ""
        var i = 1
        repeat {
            resultString += "\(result1[i])"
            i = result1[i]
        } while result1[i] != 1
        print("Task1: Labels on the cups after cup 1: \(resultString)") //24798635
        
        
        // MARK: - Task2
        
        let game = input + Array<Int>(10 ... 1_000_000)
        let result2 = playGameEfficient(with: game, moves: 10_000_000)
        let number1 = result2[1]
        let number2 = result2[number1]
        print("Task2: The multiplication of \(number1) and \(number2) is: \(number1 * number2)") //12757828710
    }
}
