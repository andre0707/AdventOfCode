import Foundation

struct Day23 {
    
    struct Position: Equatable, Hashable {
        let x: Int
        let y: Int
        
        var north: Position { Position(x: x, y: y - 1) }
        var east: Position { Position(x: x + 1, y: y) }
        var south: Position { Position(x: x, y: y + 1) }
        var west: Position { Position(x: x - 1, y: y) }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        
        let map = input.dropLast(1).components(separatedBy: .newlines).map { $0.map { $0 } }
        func mapElement(at position: Position) -> Character { map[position.y][position.x] }
        
        let maxYIndex = map.count - 1
        let maxXIndex = map[0].count - 1
        
        var steps = Array(repeating: Array(repeating: -1, count: map[0].count), count: map.count)
        func setSteps(at position: Position, to value: Int) { steps[position.y][position.x] = value }
        func stepCount(at position: Position) -> Int { steps[position.y][position.x] }
        func printStepsMap() {
            for row in steps {
                print(row.map {
                    $0 >= 0 ? "O" : " " }.joined())
            }
        }
        
        let startPosition = Position(x: map[0].firstIndex(of: ".")!, y: 0)
        let finalPosition = Position(x: map[map.count - 1].firstIndex(of: ".")!, y: map.count - 1)
        var currentPosition = startPosition
        var lastPosition = currentPosition
        setSteps(at: currentPosition, to: 0)
        
        func possibleSteps(from position: Position, with lastPosition: Position, visitedPositions: Set<Position>?) -> [Position] {
            var possibleSteps: [Position] = []
            if position.x < maxXIndex {
                let nextPosition = position.east
                let allowedFields: [Character] = visitedPositions != nil ? [".", ">", "v", "<", "^"] : [".", ">"]
                if lastPosition != nextPosition, allowedFields.contains(mapElement(at: nextPosition)), !(visitedPositions?.contains(nextPosition) ?? false) {
                    possibleSteps.append(nextPosition)
                }
            }
            if position.y < maxYIndex {
                let nextPosition = position.south
                let allowedFields: [Character] = visitedPositions != nil ? [".", ">", "v", "<", "^"] : [".", "v"]
                if lastPosition != nextPosition, allowedFields.contains(mapElement(at: nextPosition)), !(visitedPositions?.contains(nextPosition) ?? false) {
                    possibleSteps.append(nextPosition)
                }
            }
            if position.x > 0 {
                let nextPosition = position.west
                let allowedFields: [Character] = visitedPositions != nil ? [".", ">", "v", "<", "^"] : [".", "<"]
                if lastPosition != nextPosition, allowedFields.contains(mapElement(at: nextPosition)), !(visitedPositions?.contains(nextPosition) ?? false) {
                    possibleSteps.append(nextPosition)
                }
            }
            if position.y > 0 {
                let nextPosition = position.north
                let allowedFields: [Character] = visitedPositions != nil ? [".", ">", "v", "<", "^"] : [".", "^"]
                if lastPosition != nextPosition, allowedFields.contains(mapElement(at: nextPosition)), !(visitedPositions?.contains(nextPosition) ?? false) {
                    possibleSteps.append(nextPosition)
                }
            }
            
            possibleSteps.forEach {
                let nextStepCount = stepCount(at: position) + 1
                let compareStepCount = stepCount(at: $0)
                if nextStepCount > compareStepCount {
                    setSteps(at: $0, to: nextStepCount)
                }
            }
            return possibleSteps
        }
        
        
        // MARK: - Task 1
        
        var positionsToCheck: [(Position, Position)] = possibleSteps(from: currentPosition, with: lastPosition, visitedPositions: nil).map { ($0, lastPosition) }
        while !positionsToCheck.isEmpty {
            let nextToCheck = positionsToCheck.removeFirst()
            currentPosition = nextToCheck.0
            lastPosition = nextToCheck.1
            
            while currentPosition != finalPosition {
                var nextPositions = possibleSteps(from: currentPosition, with: lastPosition, visitedPositions: nil)
                
                lastPosition = currentPosition
                currentPosition = nextPositions.removeFirst()
                positionsToCheck.append(contentsOf: nextPositions.map { ($0, lastPosition) })
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The longest hike takes \(stepCount(at: finalPosition)) steps") // 2394
        
        
        // MARK: - Task 2
        
        // TODO
        
        currentPosition = startPosition
        lastPosition = currentPosition
        steps = Array(repeating: Array(repeating: -1, count: map[0].count), count: map.count)
        setSteps(at: currentPosition, to: 0)
        
        var visitedPositions: Set<Position> = []
        var positionsToCheckNext: [(Position, Position, Set<Position>)] = possibleSteps(from: currentPosition, with: lastPosition, visitedPositions: visitedPositions).map { ($0, lastPosition, visitedPositions) }
        while !positionsToCheckNext.isEmpty {
            let nextToCheck = positionsToCheckNext.removeFirst()
            currentPosition = nextToCheck.0
            lastPosition = nextToCheck.1
            visitedPositions = nextToCheck.2
            
            while currentPosition != finalPosition, !visitedPositions.contains(currentPosition) {
                var nextPositions = possibleSteps(from: currentPosition, with: lastPosition, visitedPositions: visitedPositions)
                if nextPositions.isEmpty { break }
                
                visitedPositions.insert(currentPosition)
                lastPosition = currentPosition
                currentPosition = nextPositions.removeFirst()
                positionsToCheckNext.append(contentsOf: nextPositions.map { ($0, lastPosition, visitedPositions) })
            }
            
//            printStepsMap()
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The longest hike takes \(stepCount(at: finalPosition)) steps") //
    }
}
