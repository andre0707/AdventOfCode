import Foundation

struct Day12 {
    
    final class GridPoint {
        let x: Int
        let y: Int
        
        let elevation: Int
        
        var stepsToEnd: Int?
        
        var leftNeighbor: GridPoint?
        var rightNeighbor: GridPoint?
        var topNeighbor: GridPoint?
        var bottomNeighbor: GridPoint?
        
        init(x: Int, y: Int, elevation: Int, stepsToEnd: Int? = nil, leftNeighbor: GridPoint? = nil, rightNeighbor: GridPoint? = nil, topNeighbor: GridPoint? = nil, bottomNeighbor: GridPoint? = nil) {
            self.x = x
            self.y = y
            self.elevation = elevation
            self.stepsToEnd = stepsToEnd
            self.leftNeighbor = leftNeighbor
            self.rightNeighbor = rightNeighbor
            self.topNeighbor = topNeighbor
            self.bottomNeighbor = bottomNeighbor
        }
        
        var haveAllNeighborsStepsToEndFilled: Bool {
            if leftNeighbor != nil && leftNeighbor!.stepsToEnd == nil { return false }
            if rightNeighbor != nil && rightNeighbor!.stepsToEnd == nil { return false }
            if topNeighbor != nil && topNeighbor!.stepsToEnd == nil { return false }
            if bottomNeighbor != nil && bottomNeighbor!.stepsToEnd == nil { return false }
            return true
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day12", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let heightmapHeight = inputRows.count
        let heightmapWidth = inputRows[0].count
        
        var startPoint: GridPoint!
        var endPoint: GridPoint!
        
        var heightmap: [[GridPoint]] = []
        // Fill `heightmap` with input data
        for (y, row) in inputRows.enumerated() {
            var heightmapRow: [GridPoint] = []
            for (x, char) in row.enumerated() {
                switch char {
                case "S":
                    startPoint = GridPoint(x: x, y: y, elevation: 1)
                    heightmapRow.append(startPoint)
                case "E":
                    endPoint = GridPoint(x: x, y: y, elevation: 26, stepsToEnd: 0)
                    heightmapRow.append(endPoint)
                default:
                    let point = GridPoint(x: x, y: y, elevation: Int(char.asciiValue!) - 96)
                    heightmapRow.append(point)
                }
            }
            heightmap.append(heightmapRow)
        }
        // Fill neighbars in `heightmap`
        for (y, row) in heightmap.enumerated() {
            for (x, point) in row.enumerated() {
                
                if y - 1 >= 0 {
                    let potentialNeighbor = heightmap[y - 1][x]
                    
                    if (-2...1).contains(point.elevation - potentialNeighbor.elevation) {
                        point.topNeighbor = potentialNeighbor
                    }
                }
                if y + 1 < heightmapHeight {
                    let potentialNeighbor = heightmap[y + 1][x]
                    
                    if (-2...1).contains(point.elevation - potentialNeighbor.elevation) {
                        point.bottomNeighbor = potentialNeighbor
                    }
                }
                if x - 1 >= 0 {
                    let potentialNeighbor = heightmap[y][x - 1]
                    
                    if (-2...1).contains(point.elevation - potentialNeighbor.elevation) {
                        point.leftNeighbor = potentialNeighbor
                    }
                }
                if x + 1 < heightmapWidth {
                    let potentialNeighbor = heightmap[y][x + 1]
                    
                    if (-2...1).contains(point.elevation - potentialNeighbor.elevation) {
                        point.rightNeighbor = potentialNeighbor
                    }
                }
            }
        }
        
        var elementsToCheck: [GridPoint] = [endPoint!]
        
        while !elementsToCheck.isEmpty {
            let sourceElement = elementsToCheck.removeFirst()
            
            if let neighbor = sourceElement.topNeighbor, (-2...1).contains(sourceElement.elevation - neighbor.elevation) {
                if neighbor.stepsToEnd == nil || neighbor.stepsToEnd! > sourceElement.stepsToEnd! + 1 {
                    neighbor.stepsToEnd = sourceElement.stepsToEnd! + 1
                    elementsToCheck.append(neighbor)
                }
            }
            if let neighbor = sourceElement.bottomNeighbor, (-2...1).contains(sourceElement.elevation - neighbor.elevation) {
                if neighbor.stepsToEnd == nil || neighbor.stepsToEnd! > sourceElement.stepsToEnd! + 1 {
                    neighbor.stepsToEnd = sourceElement.stepsToEnd! + 1
                    elementsToCheck.append(neighbor)
                }
            }
            if let neighbor = sourceElement.leftNeighbor, (-2...1).contains(sourceElement.elevation - neighbor.elevation) {
                if neighbor.stepsToEnd == nil || neighbor.stepsToEnd! > sourceElement.stepsToEnd! + 1 {
                    neighbor.stepsToEnd = sourceElement.stepsToEnd! + 1
                    elementsToCheck.append(neighbor)
                }
            }
            if let neighbor = sourceElement.rightNeighbor, (-2...1).contains(sourceElement.elevation - neighbor.elevation) {
                if neighbor.stepsToEnd == nil || neighbor.stepsToEnd! > sourceElement.stepsToEnd! + 1 {
                    neighbor.stepsToEnd = sourceElement.stepsToEnd! + 1
                    elementsToCheck.append(neighbor)
                }
            }
            
            if !sourceElement.haveAllNeighborsStepsToEndFilled {
                elementsToCheck.append(sourceElement)
            }
        }
        
        /// Draw map
//        for row in heightmap {
//            print(row.map { $0.stepsToEnd != nil ? "O" : "." }.joined())
//        }
                
        
        // MARK: - Task 1
        
        
        let stepCount = startPoint.stepsToEnd!
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Fastest way takes \(stepCount) steps")
        
        
        // MARK: - Task 2
        
        let fewestSteps = heightmap
            .flatMap { $0 }
            .filter { $0.elevation == 1 }
            .compactMap { $0.stepsToEnd }
            .sorted()
            .first!
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Fewest steps from any elevation with 1 is: \(fewestSteps)")
    }
}












// MARK: - Attempt 1: recursive will not work for larger datasets..

extension Day12 {
    struct Point: Equatable {
        let x: Int
        let y: Int
        
        func leftNeighbor() -> Point? {
            guard x > 0 else { return nil }
            return Point(x: x - 1, y: y)
        }
        func rightNeighbor(max: Int) -> Point? {
            guard x + 1 < max else { return nil }
            return Point(x: x + 1, y: y)
        }
        func topNeighbor() -> Point? {
            guard y > 0 else { return nil }
            return Point(x: x, y: y - 1)
        }
        func bottomNeighbor(max: Int) -> Point? {
            guard y + 1 < max else { return nil }
            return Point(x: x, y: y + 1)
        }
    }
    
    static func run1() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day12", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let heightmapHeight = inputRows.count
        let heightmapWidth = inputRows[0].count
        
        var heightmap = Array(repeating: Array(repeating: 0, count: heightmapWidth), count: heightmapHeight)
        var startPoint: Point!
        var endPoint: Point!

        for (yIndex, row) in inputRows.enumerated() {
            for (xIndex, char) in row.enumerated() {
                switch char {
                case "S":
                    heightmap[yIndex][xIndex] = 1
                    startPoint = Point(x: xIndex, y: yIndex)
                case "E":
                    heightmap[yIndex][xIndex] = 26
                    endPoint = Point(x: xIndex, y: yIndex)
                default:
                    heightmap[yIndex][xIndex] = Int(char.asciiValue!) - 96
                }
            }
        }
        
        
        // MARK: - Task 1
        
        var moveHistory: [[Point]] = []
        var currentMoveHistory: [Point] = [startPoint]

        func makeMove() {
            guard currentMoveHistory.last! != endPoint else {
                moveHistory.append(currentMoveHistory)
                currentMoveHistory.removeLast()
                return
            }


            if let next = currentMoveHistory.last!.rightNeighbor(max: heightmapWidth), !currentMoveHistory.contains(next) {
                let dHeight = heightmap[next.y][next.x] - heightmap[currentMoveHistory.last!.y][currentMoveHistory.last!.x]
                if (0...1).contains(dHeight) {
                    currentMoveHistory.append(next)
                    makeMove()
                }
            }
            if let next = currentMoveHistory.last!.bottomNeighbor(max: heightmapHeight), !currentMoveHistory.contains(next) {
                let dHeight = heightmap[next.y][next.x] - heightmap[currentMoveHistory.last!.y][currentMoveHistory.last!.x]
                if (0...1).contains(dHeight) {
                    currentMoveHistory.append(next)
                    makeMove()
                }
            }
            if let next = currentMoveHistory.last!.leftNeighbor(), !currentMoveHistory.contains(next) {
                let dHeight = heightmap[next.y][next.x] - heightmap[currentMoveHistory.last!.y][currentMoveHistory.last!.x]
                if (0...1).contains(dHeight) {
                    currentMoveHistory.append(next)
                    makeMove()
                }
            }
            if let next = currentMoveHistory.last!.topNeighbor(), !currentMoveHistory.contains(next) {
                let dHeight = heightmap[next.y][next.x] - heightmap[currentMoveHistory.last!.y][currentMoveHistory.last!.x]
                if (0...1).contains(dHeight) {
                    currentMoveHistory.append(next)
                    makeMove()
                }
            }

            currentMoveHistory.removeLast()
        }

        makeMove()


        let stepCount = moveHistory.map { $0.count }.min()! - 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Fastest way takes \(stepCount) steps")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
