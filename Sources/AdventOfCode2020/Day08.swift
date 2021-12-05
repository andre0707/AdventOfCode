import Foundation

enum Instruction {
    case nop(Int)
    case acc(Int)
    case jmp(Int)
}

struct InstructionSet {
    var executedBefore = false
    var instruction: Instruction
    
    init?(from string: String) {
        if string.isEmpty { return nil }
        
        let components = string.components(separatedBy: .whitespaces)
        let value = Int(components[1])!
        switch components[0] {
            case "nop":
                self.instruction = .nop(value)
            case "acc":
                self.instruction = .acc(value)
            case "jmp":
                self.instruction = .jmp(value)
            default:
                return nil
        }
    }
    
    mutating func toggleInstruction() {
        switch self.instruction {
            case .nop(let value):
                self.instruction = .jmp(value)
            case .acc:
                return
            case .jmp(let value):
                self.instruction = .nop(value)
        }
    }
}

struct Day8 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day08", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines)
        
        let instructions = inputLines.compactMap { InstructionSet(from: $0) }
        
        
        // return (false, value) if instructions ended in endless loop
        func runInstructions(_ instructions: [InstructionSet]) -> (Bool, Int) {
            var accumulatorCount = 0
            var position = 0
            var _instructions = instructions
            while (position >= 0 && position < _instructions.count) {
                if _instructions[position].executedBefore { return (false, accumulatorCount) }
                _instructions[position].executedBefore = true
                
                switch _instructions[position].instruction {
                    case .nop:
                        position += 1
                    case .acc(let value):
                        accumulatorCount += value
                        position += 1
                    case .jmp(let value):
                        position += value
                }
            }
            
            return (true, accumulatorCount)
        }
        
        print("The accumulator has the value: \(runInstructions(instructions).1)")
        
        
        for i in 0 ..< instructions.count {
            switch instructions[i].instruction {
                case .acc(_):
                    continue
                default:
                    break
            }
            
            var _instructions = instructions
            var instruction = _instructions[i]
            instruction.toggleInstruction()
            _instructions.replaceSubrange(i ... i, with: [instruction])
            
            let result = runInstructions(_instructions)
            if !result.0 { continue }
            
            print("When running finishes, the accumulator has the value: \(result.1)")
        }
    }
}
