import Foundation

struct Day14 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day14", ofType: "txt")!)
            .components(separatedBy: "\n\n")

        /// Get the starting polymere
        let polymere = input[0]

        /// Fill the pair instruction dictionary
        var pairInsertionInstructions = [String: String]()
        input[1]
            .components(separatedBy: .newlines)
            .forEach { instruction in
                if instruction.isEmpty { return }
                let components = instruction.components(separatedBy: " -> ")
                pairInsertionInstructions[components[0]] = components[1]
            }
        
        
        // MARK: - Task 1
        
        
        /// Idea: build the whole result string by inserting the string for each pair we find.
        /// Loop over the current result string `step` times.
        var result = polymere
        
        func run(steps: Int, printSteps: Bool = false) {
            for step in 1 ... steps {
                var firstIndex = result.startIndex
                var secondIndex = result.index(after: firstIndex)
                
                while secondIndex != result.endIndex {
                    let pair = String(result[firstIndex ... secondIndex])
                    if let insertion = pairInsertionInstructions[pair] {
                        result.insert(contentsOf: insertion, at: secondIndex)
                        firstIndex = result.index(after: secondIndex)
                        
                    } else {
                        firstIndex = secondIndex
                    }
                    secondIndex = result.index(after: firstIndex)
                }
                
                if printSteps {
                    print("After step \(step): \(result)")
                }
            }
        }
        
        run(steps: 10)
        var charCounter = [Character : Int]()
        for char in result {
            charCounter[char, default: 0] += 1
        }
        print("Result task 1: \(charCounter.values.max()! - charCounter.values.min()!)")
        
        
        // MARK: - Task 2
        
        /// Task 1 solution is way too slow and needs way too much memory for a huge amount of steps.
        /// New idea: just calculate the pairs and keep count of them. Inserting a string in a pair will result in 2 new pairs.
        /// Example: Insertion rule AB -> C will turn the pair [AB] into the following two pairs [AC, CB]
        
        func run2(steps: Int) -> Int {
            var currentPairsCounter = [String : Int]()
            /// Count the pairs in the starting polymore string
            var lastChar: Character? = nil
            for char in polymere {
                if lastChar == nil {
                    lastChar = char
                    continue
                }
                let pair = String([lastChar!, char])
                currentPairsCounter[pair, default: 0] += 1
                lastChar = char
            }
            
            /// Repeat steps times the calculation for the count of pairs
            for _ in 1 ... steps {
                /// Calculate the next pairs from the current pairs
                var nextPairsCounter = [String : Int]()
                for pair in currentPairsCounter.keys {
                    nextPairsCounter[String(pair[pair.startIndex]) + pairInsertionInstructions[pair]!, default: 0] += currentPairsCounter[pair]!
                    nextPairsCounter[pairInsertionInstructions[pair]! + String(pair[pair.index(before: pair.endIndex)]), default: 0] += currentPairsCounter[pair]!
                }
                currentPairsCounter = nextPairsCounter
            }
            
            /// Check how many of each characters we have. All (but the last character from the starting polymore) will be at first at a first position of the pairs
            var characterCount = [Character : Int]()
            characterCount[polymere[polymere.index(before: polymere.endIndex)]] = 1
            for pair in currentPairsCounter.keys {
                characterCount[pair[pair.startIndex], default: 0] += currentPairsCounter[pair]!
            }
            
            return characterCount.values.max()! - characterCount.values.min()!
        }
        
        print("Result task 2: \(run2(steps: 40))")
    }
}
