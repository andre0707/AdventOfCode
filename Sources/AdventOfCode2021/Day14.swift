import Foundation

struct Day14 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
            .components(separatedBy: "\n\n")

        let polymere = input[0]

        var pairInsertionInstructions = [String: String]()
        
        input[1]
            .components(separatedBy: .newlines)
            .forEach { instruction in
                if instruction.isEmpty { return }
                let components = instruction.components(separatedBy: " -> ")
                pairInsertionInstructions[components[0]] = components[1]
            }
        
        
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
        
        
        // MARK: - Task 1
        
        run(steps: 10)
        var charCounter = [Character : Int]()
        for char in result {
            charCounter[char, default: 0] += 1
        }
        print("Result task 1: \(charCounter.values.max()! - charCounter.values.min()!)")
        
        
        // MARK: - Task 2
        
        
        
        
    }
}
