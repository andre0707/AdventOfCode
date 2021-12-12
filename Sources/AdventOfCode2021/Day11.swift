import Foundation

struct Day11 {
    
    typealias Position = (row: Int, column: Int)
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day11", ofType: "txt")!)
            .components(separatedBy: .newlines)
        
        var map = input.map { $0.compactMap { $0.wholeNumberValue } }
        
        func increment(at position: Position) {
            guard position.row >= 0, position.row < map.count else { return }
            guard position.column >= 0, position.column < map[position.row].count else { return }
            map[position.row][position.column] += 1
        }
        
        func adjacentPositions(for position: Position) -> [Position] {
            var result = [Position]()
            for row in position.row - 1 ... position.row + 1 {
                for column in position.column - 1 ... position.column + 1 {
                    guard row != position.row || column != position.column else { continue } /// Not self position
                    guard row >= 0, row < map.count, column >= 0, column < map[row].count else { continue } /// Make sure its a valid position
                    result.append((row: row, column: column))
                }
            }
            return result
        }
        
        var currentStep = 0
        var counterTotalFlashesFor100Steps = 0
        var counterFlashesInCurrentStep = 0
        while true {
            currentStep += 1
            counterFlashesInCurrentStep = 0
            var flashPositions = [Position]()
            for row in 0 ..< map.count {
                for column in 0 ..< map[row].count {
                    increment(at: (row, column))
                    
                    if map[row][column] == 10 {
                        if currentStep <= 100 {
                            counterTotalFlashesFor100Steps += 1
                        }
                        counterFlashesInCurrentStep += 1
                        flashPositions.append((row, column))
                    }
                }
            }
            
            while !flashPositions.isEmpty {
                let currentPoint = flashPositions.removeLast()
                let adjacents = adjacentPositions(for: currentPoint)
                for adjacent in adjacents {
                    increment(at: (adjacent.row, adjacent.column))
                    
                    if map[adjacent.row][adjacent.column] == 10 {
                        if currentStep <= 100 {
                            counterTotalFlashesFor100Steps += 1
                        }
                        counterFlashesInCurrentStep += 1
                        flashPositions.append((adjacent.row, adjacent.column))
                    }
                }
            }
            
            for row in 0 ..< map.count {
                for column in 0 ..< map[row].count {
                    if map[row][column] > 9 {
                        map[row][column] = 0
                    }
                }
            }
            
            if counterFlashesInCurrentStep == 100 { break }
        }
        
        
        // MARK: - Task 1
        
        print("There were \(counterTotalFlashesFor100Steps) flashes in the first 100 steps.")
        
        
        // MARK: - Task 2
        
        print("All 100 fish synchronize flash the fist time at step: \(currentStep)")
    }
}
