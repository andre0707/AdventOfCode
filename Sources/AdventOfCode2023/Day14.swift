import Foundation

struct Day14 {
    
    enum Direction {
        case north
        case west
        case south
        case east
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        var grid = inputRows.map { $0.map { $0 } }
        
        // roll north
        func tiltGrid(in direction: Direction) {
            switch direction {
            case .north:
                for rowIndex in 0 ..< grid.count {
                    for columnIndex in 0 ..< grid[rowIndex].count {
                        guard grid[rowIndex][columnIndex] == "O" else { continue }
                        var destinationRowIndex = rowIndex - 1
                        while destinationRowIndex >= 0 && grid[destinationRowIndex][columnIndex] == "." {
                            destinationRowIndex -= 1
                        }
                        if destinationRowIndex != rowIndex {
                            grid[rowIndex][columnIndex] = "."
                            grid[destinationRowIndex + 1][columnIndex] = "O"
                        }
                    }
                }
            case .west:
                for rowIndex in 0 ..< grid.count {
                    for columnIndex in 0 ..< grid[rowIndex].count {
                        guard grid[rowIndex][columnIndex] == "O" else { continue }
                        var destinationColumnIndex = columnIndex - 1
                        while destinationColumnIndex >= 0 && grid[rowIndex][destinationColumnIndex] == "." {
                            destinationColumnIndex -= 1
                        }
                        if destinationColumnIndex != columnIndex {
                            grid[rowIndex][columnIndex] = "."
                            grid[rowIndex][destinationColumnIndex + 1] = "O"
                        }
                    }
                }
            case .south:
                for rowIndex in (0 ..< grid.count).reversed() {
                    for columnIndex in 0 ..< grid[rowIndex].count {
                        guard grid[rowIndex][columnIndex] == "O" else { continue }
                        var destinationRowIndex = rowIndex + 1
                        while destinationRowIndex < grid.count && grid[destinationRowIndex][columnIndex] == "." {
                            destinationRowIndex += 1
                        }
                        if destinationRowIndex != rowIndex {
                            grid[rowIndex][columnIndex] = "."
                            grid[destinationRowIndex - 1][columnIndex] = "O"
                        }
                    }
                }
            case .east:
                for rowIndex in 0 ..< grid.count {
                    for columnIndex in (0 ..< grid[rowIndex].count).reversed() {
                        guard grid[rowIndex][columnIndex] == "O" else { continue }
                        var destinationColumnIndex = columnIndex + 1
                        while destinationColumnIndex < grid[rowIndex].count && grid[rowIndex][destinationColumnIndex] == "." {
                            destinationColumnIndex += 1
                        }
                        if destinationColumnIndex != columnIndex {
                            grid[rowIndex][columnIndex] = "."
                            grid[rowIndex][destinationColumnIndex - 1] = "O"
                        }
                    }
                }
            }
        }
        
        func printGrid() {
            for row in grid {
                print(row.map { String($0) }.joined())
            }
            print("---------------------------------------")
        }
        
        // MARK: - Task 1
        
        tiltGrid(in: .north)
        
        var totalLoad = 0
        for rowIndex in 0 ..< grid.count {
            totalLoad += grid[rowIndex].filter { $0 == "O" }.count * (grid.count - rowIndex)
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Total load: \(totalLoad)") // 113424
        
        
        // MARK: - Task 2
        
        tiltGrid(in: .west)
        tiltGrid(in: .south)
        tiltGrid(in: .east)
        
        for _ in 1 ..< 1_000_000_000 {
            tiltGrid(in: .north)
            tiltGrid(in: .west)
            tiltGrid(in: .south)
            tiltGrid(in: .east)
        }
        
        totalLoad = 0
        for rowIndex in 0 ..< grid.count {
            totalLoad += grid[rowIndex].filter { $0 == "O" }.count * (grid.count - rowIndex)
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Total load: \(totalLoad)") //
    }
}
