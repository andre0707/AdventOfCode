import Foundation

struct Day10 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day10", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        var indexNextInstruction = 0
        var workingOnAddCommand = false
        
        var cycleCount = 0
        var x = 1
        var signalStrengths: [Int] = []
        
        let interestingCycles = [20, 60, 100, 140, 180, 220]
        
        var displayRows: [String] = []
        var currentDisplayRow = ""
        
        while indexNextInstruction < inputRows.count {
            cycleCount += 1
            
            if interestingCycles.contains(cycleCount) {
                signalStrengths.append(cycleCount * x)
            }
            
            currentDisplayRow += (x-1...x+1).contains(currentDisplayRow.count) ? "#" : "."
            if currentDisplayRow.count % 40 == 0 {
                displayRows.append(currentDisplayRow)
                currentDisplayRow = ""
            }
            
            let instruction = inputRows[indexNextInstruction]
            
            if instruction.prefix(4) == "noop" {
                indexNextInstruction += 1
                continue
            }
            
            if !workingOnAddCommand {
                workingOnAddCommand = true
                continue
            }
            
            workingOnAddCommand = false
            indexNextInstruction += 1
            x += Int(instruction.components(separatedBy: .whitespaces)[1])!
            
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum is: \(signalStrengths.reduce(0, +))")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        for displayRow in displayRows {
            print(displayRow)
        }
    }
}
