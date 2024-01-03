import Foundation

struct Day21 {
    
    struct Location: Hashable {
        let x: Int
        let y: Int
    }
    
    class MapPoint: Equatable, Hashable {
        static func == (lhs: Day21.MapPoint, rhs: Day21.MapPoint) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        let x: Int
        let y: Int
        var stepsToReach: Int? = nil
        
        var topNeighbour: MapPoint? = nil
        var rightNeighbour: MapPoint? = nil
        var bottomNeighbour: MapPoint? = nil
        var leftNeighbour: MapPoint? = nil
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day21", ofType: "txt")!)
        let inputRows = input.dropLast(1).components(separatedBy: .newlines)
        
        var mapPoints: [Location: MapPoint] = [:]
        var start: MapPoint!
        for (rowIndex, row) in inputRows.enumerated() {
            for (columnIndex, char) in row.enumerated() {
                guard char != "#" else { continue }
                let mapPoint = MapPoint(x: columnIndex, y: rowIndex)
                mapPoints[Location(x: columnIndex, y: rowIndex)] = mapPoint
                if char == "S" {
                    start = mapPoint
                    start.stepsToReach = 0
                }
                if rowIndex > 0 {
                    let topNeighbour = mapPoints[Location(x: columnIndex, y: rowIndex - 1)]
                    mapPoint.topNeighbour = topNeighbour
                    topNeighbour?.bottomNeighbour = mapPoint
                }
                if columnIndex > 0 {
                    let leftNeighbour = mapPoints[Location(x: columnIndex - 1, y: rowIndex)]
                    mapPoint.leftNeighbour = leftNeighbour
                    leftNeighbour?.rightNeighbour = mapPoint
                }
            }
        }
        
        
        func setSteps(to mapPoint: MapPoint) {
            if let neighbour = mapPoint.topNeighbour {
                if let stepsToReach = neighbour.stepsToReach {
                    if mapPoint.stepsToReach! + 1 < stepsToReach {
                        neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                        setSteps(to: neighbour)
                    }
                } else {
                    neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                    setSteps(to: neighbour)
                }
            }
            
            if let neighbour = mapPoint.rightNeighbour {
                if let stepsToReach = neighbour.stepsToReach {
                    if mapPoint.stepsToReach! + 1 < stepsToReach {
                        neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                        setSteps(to: neighbour)
                    }
                } else {
                    neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                    setSteps(to: neighbour)
                }
            }
            
            if let neighbour = mapPoint.bottomNeighbour {
                if let stepsToReach = neighbour.stepsToReach {
                    if mapPoint.stepsToReach! + 1 < stepsToReach {
                        neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                        setSteps(to: neighbour)
                    }
                } else {
                    neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                    setSteps(to: neighbour)
                }
            }
            if let neighbour = mapPoint.leftNeighbour {
                if let stepsToReach = neighbour.stepsToReach {
                    if mapPoint.stepsToReach! + 1 < stepsToReach {
                        neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                        setSteps(to: neighbour)
                    }
                } else {
                    neighbour.stepsToReach = mapPoint.stepsToReach! + 1
                    setSteps(to: neighbour)
                }
            }
        }
        
        setSteps(to: start)
        
//        for row in 0 ..< inputRows.count {
//            var rowText = ""
//            for column in 0 ..< inputRows[row].count {
//                if let steps = mapPoints[Location(x: column, y: row)]?.stepsToReach {
//                    rowText += steps <= 9 ? "\(steps)" : "?"
//                } else {
//                    rowText += "#"
//                }
//            }
//            print(rowText)
//        }
        
        
        // MARK: - Task 1
        
        let availableSteps = 64
        
        let reachableGardenPlots = mapPoints.values.filter {
            guard let stepsToReach = $0.stepsToReach, stepsToReach <= availableSteps else { return false }
            if stepsToReach == availableSteps { return true }
            if stepsToReach == 0 { return availableSteps % 2 == 0 }
            return stepsToReach % 2 == availableSteps % 2
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The elf can reach \(reachableGardenPlots.count) garden plots") // 3682
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
