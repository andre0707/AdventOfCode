import Foundation

struct Day8 {
    
    static func greatestCommeonDivisor(_ num1: Int, _ num2: Int) -> Int {
        var x = 0
        var y: Int = max(num1, num2)
        var z: Int = min(num1, num2)
        
        while z != 0 {
            x = y
            y = z
            z = x % y
        }
        return y
    }
    
    static func leastCommonMultiple(_ num1: Int, _ num2: Int) -> Int {
        (num1 * num2 / greatestCommeonDivisor(num1, num2))
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day08", ofType: "txt")!)
        
        let inputComponents = input.components(separatedBy: "\n\n").filter { !$0.isEmpty }
        let mappingInstructionLines = inputComponents[1].components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let turnInstructions = inputComponents[0]
        
        var mapInstructions: [String : (String, String)] = [:]
        for mapInstruction in mappingInstructionLines {
            let mappingComponents = mapInstruction.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").components(separatedBy: " = ")
            let mappingValues = mappingComponents[1].components(separatedBy: ", ")
            
            mapInstructions[mappingComponents[0]] = (mappingValues[0], mappingValues[1])
        }
        
        
        // MARK: - Task 1
        
        var currentPosition = "AAA"
        let destinationPosition = "ZZZ"
        var takenSteps = 0
        
        while currentPosition != destinationPosition {
            let turnInstruction = turnInstructions[turnInstructions.index(turnInstructions.startIndex, offsetBy: takenSteps % turnInstructions.count)]
            takenSteps += 1
            
            currentPosition = turnInstruction == "L" ? mapInstructions[currentPosition]!.0 : mapInstructions[currentPosition]!.1
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("It took \(takenSteps) steps to get to ZZZ") // 14257
        
        
        // MARK: - Task 2
        
        var currentPositions = mapInstructions.keys.filter { $0.hasSuffix("A") }
        var takenStepsList: [Int] = []
        
        for index in 0 ..< currentPositions.count {
            takenSteps = 0
            
            while !currentPositions[index].hasSuffix("Z") {
                let turnInstruction = turnInstructions[turnInstructions.index(turnInstructions.startIndex, offsetBy: takenSteps % turnInstructions.count)]
                takenSteps += 1
                currentPositions[index] = turnInstruction == "L" ? mapInstructions[currentPositions[index]]!.0 : mapInstructions[currentPositions[index]]!.1
            }
            takenStepsList.append(takenSteps)
        }
        
        takenSteps = takenStepsList[0]
        if takenStepsList.count > 1 {
            for index in 1 ..< takenStepsList.count {
                takenSteps = Day8.leastCommonMultiple(takenSteps, takenStepsList[index])
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("It took \(takenSteps) steps to get to ??Z") // 16187743689077
    }
}

