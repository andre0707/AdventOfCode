import Foundation

struct Day11 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day11", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let universeMap = inputRows.map { $0.map { $0 } }
        
        var emptyRowIndices: [Int] = []
        for (rowIndex, row) in universeMap.enumerated() {
            if row.allSatisfy({ $0 == "."}) {
                emptyRowIndices.append(rowIndex)
            }
        }
        var emptyColumnIndices: [Int] = []
        for columnIndex in 0 ..< universeMap[0].count {
            var isEmptyColumn = true
            for rowIndex in 0 ..< universeMap.count {
                if universeMap[rowIndex][columnIndex] != "." {
                    isEmptyColumn = false
                    break
                }
            }
            if isEmptyColumn {
                emptyColumnIndices.append(columnIndex)
            }
        }
        
        var galaxyPositions: [(Int, Int)] = []
        for rowIndex in 0 ..< universeMap.count {
            for columnIndex in 0 ..< universeMap[rowIndex].count {
                if universeMap[rowIndex][columnIndex] == "#" {
                    galaxyPositions.append((columnIndex, rowIndex))
                }
            }
        }
        
        func distances(withExtraStepFactor: Int) -> [Int] {
            var distances: [Int] = []
            for index in 0 ..< galaxyPositions.count {
                for index2 in index + 1 ..< galaxyPositions.count {
                    let positionOne = galaxyPositions[index]
                    let positionTwo = galaxyPositions[index2]
                    
                    let deltaX = positionOne.0 < positionTwo.0 ? positionOne.0 ..< positionTwo.0 : positionTwo.0 ..< positionOne.0
                    let deltaY = positionOne.1 < positionTwo.1 ? positionOne.1 ..< positionTwo.1 : positionTwo.1 ..< positionOne.1
                    
                    var extraSteps = 0
                    for emptyColumnIndex in emptyColumnIndices {
                        if deltaX.contains(emptyColumnIndex) {
                            extraSteps += 1
                        }
                    }
                    for emptyRowIndex in emptyRowIndices {
                        if deltaY.contains(emptyRowIndex) {
                            extraSteps += 1
                        }
                    }
                    
                    let distance = deltaX.count + deltaY.count + extraSteps * withExtraStepFactor
                    distances.append(distance)
                }
            }
            return distances
        }
        
        
        // MARK: - Task 1
        
        var sumOfDistances = distances(withExtraStepFactor: 1).reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum of all the distances is: \(sumOfDistances)") // 9370588
        
        
        // MARK: - Task 2
        
        sumOfDistances = distances(withExtraStepFactor: (1_000_000 - 1)).reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The sum of all the distances is: \(sumOfDistances)") // 746207878188
    }
}
