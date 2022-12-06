import Foundation

struct Day5 {
    
    struct Instruction {
        let from: Int
        let to: Int
        let amount: Int
        
        init?(with instructionString: String) {
            guard !instructionString.isEmpty else { return nil }
            let instructions = instructionString.replacingOccurrences(of: "move ", with: "")
                .replacingOccurrences(of: " from ", with: ";")
                .replacingOccurrences(of: " to ", with: ";")
                .components(separatedBy: ";")
            
            guard instructions.count == 3 else { return nil }
            
            self.amount = Int(instructions[0])!
            self.from = Int(instructions[1])! - 1 /// -1 to match the index in the array later
            self.to = Int(instructions[2])! - 1 /// -1 to match the index in the array later
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day05", ofType: "txt")!)
        let inputRows = input.components(separatedBy: "\n\n").filter { !$0.isEmpty }
        
        let stackStartValues = inputRows[0].components(separatedBy: .newlines)
        
        let instructions = inputRows[1]
            .components(separatedBy: .newlines)
            .compactMap { Instruction(with: $0) }
        
        
        let numberOfStacks = Int(stackStartValues.last!.components(separatedBy: " ").last!)!
        
        var stacks: [[String]] = Array(repeating: [], count: numberOfStacks)
        
        stackStartValues.reversed()[1...].forEach { line in
            
            (0...((line.count) / 4)).forEach { element in
                let startIndex = line.index(line.startIndex, offsetBy: element * 4)
                let endIndex = line.index(startIndex, offsetBy: 4, limitedBy: line.endIndex) ?? line.index(startIndex, offsetBy: 3)
                
                let value = line[startIndex..<endIndex].trimmingCharacters(in: CharacterSet(charactersIn: " []"))
                if !value.isEmpty {
                    stacks[element].append(value)
                }
            }
        }
        
        
        var stacks1 = stacks
        var stacks2 = stacks
        
        
        // MARK: - Task 1
        
        for instruction in instructions {
            (0..<instruction.amount).forEach { _ in
                if let lastElement = stacks1[instruction.from].popLast() {
                    stacks1[instruction.to].append(lastElement)
                }
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Top stack elements: \(stacks1.reduce(into: "", { $0 += $1.last ?? "?" }))")
        
        
        // MARK: - Task 2
        
        for instruction in instructions {
            let elementsToMove = stacks2[instruction.from].suffix(instruction.amount)
            stacks2[instruction.from].removeLast(instruction.amount)
            stacks2[instruction.to].append(contentsOf: elementsToMove)
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Top stack elements: \(stacks2.reduce(into: "", { $0 += $1.last ?? "?" }))")
    }
}
