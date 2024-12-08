import Foundation

struct Day8 {
    
    struct Point: Hashable {
        let x: Int
        let y: Int
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day08", ofType: "txt")!)
        let grid = input.dropLast(1).components(separatedBy: .newlines)
            .map { $0.map { $0 } }
        
        var antennaPositions: [Character: [Point]] = [:]
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                guard grid[y][x] != "." else { continue }
                antennaPositions[grid[y][x], default: []].append(Point(x: x, y: y))
            }
        }
        
        var antinodesTask1: Set<Point> = []
        var antinodesTask2: Set<Point> = []
        
        for antenna in antennaPositions {
            for indexA in 0..<antenna.value.count {
                for indexB in 0..<antenna.value.count {
                    guard indexA != indexB else { continue }
                    let antennaA = antenna.value[indexA]
                    let antennaB = antenna.value[indexB]
                    
                    let deltaX = antennaA.x - antennaB.x
                    let deltaY = antennaA.y - antennaB.y
                    
                    antinodesTask2.insert(antennaA)
                    antinodesTask2.insert(antennaB)
                    
                    var multiplier: Int = 1
                    while true {
                        defer { multiplier += 1 }
                        
                        let resultingX = antennaA.x + multiplier * deltaX
                        guard resultingX >= 0, resultingX < grid[0].count else { break }
                        let resultingY = antennaA.y + multiplier * deltaY
                        guard resultingY >= 0, resultingY < grid.count else { break }
                        
                        if multiplier == 1 {
                            antinodesTask1.insert(Point(x: resultingX, y: resultingY))
                        }
                        antinodesTask2.insert(Point(x: resultingX, y: resultingY))
                    }
                }
            }
        }
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(antinodesTask1.count) // 308
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(antinodesTask2.count) // 1147
    }
}

