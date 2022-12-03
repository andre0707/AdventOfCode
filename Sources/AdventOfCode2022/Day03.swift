import Foundation


extension Character {
    var priority: Int? {
        guard let asciiValue else { return nil }
        
        if self.isLowercase {
            return Int(asciiValue) - 96
        } else {
            return Int(asciiValue) - 38
        }
    }
}

struct Day3 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day03", ofType: "txt")!)
        
        let rucksacks = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            
        
        
        // MARK: - Task 1
        
        let rucksacksByCompartments = rucksacks.map {
            let indexMiddle = $0.index($0.startIndex, offsetBy: $0.count / 2)
            
            return ($0[..<indexMiddle], $0[indexMiddle...])
        }
        
        let commonItemsByRucksack = rucksacksByCompartments.map {
            let compartment1 = Set($0.0.map { $0 })
            let compartment2 = Set($0.1.map { $0 })
            
            return compartment1.intersection(compartment2).map { $0.priority! }
        }
        
        let scoreTask1 = commonItemsByRucksack.flatMap { $0 }.reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The score is \(scoreTask1)")
        
        
        // MARK: - Task 2
        
        let priorityOfCommenItemsByGroups = stride(from: 0, to: rucksacks.count, by: 3).map {
            let transformedRucksacks = rucksacks[$0..<($0 + 3)].map {
                Set($0.map { $0 })
            }
            
            return transformedRucksacks[0].intersection(transformedRucksacks[1]).intersection(transformedRucksacks[2])
                .map { $0.priority! }
        }
        
        let scoreTask2 = priorityOfCommenItemsByGroups.flatMap { $0 }.reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The score is \(scoreTask2)")
    }
}
