import Foundation

struct Day6 {
    
    enum MovingDirection {
        case up
        case down
        case left
        case right
        
        var nextDirection: MovingDirection {
            switch self {
            case .up:
                return .right
            case .down:
                return .left
            case .left:
                return .up
            case .right:
                return .down
            }
        }
    }
    
    struct LocationPoint: Hashable {
        let x: Int
        let y: Int
    }
    
    struct LocationPointWithDirection: Hashable {
        let x: Int
        let y: Int
        let direction: MovingDirection
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day06", ofType: "txt")!)
        
        let map = input.dropLast(1)
            .components(separatedBy: .newlines)
            .map { $0.map { $0 } }
        
        var currentGuardPosition = LocationPoint(x: 0, y: 0)
        outer: for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == "^" {
                    currentGuardPosition = LocationPoint(x: x, y: y)
                    break outer
                }
            }
        }
        
        let guardStartPosition = currentGuardPosition
        
        // MARK: - Task 1
        
        var guardMovingDirection: MovingDirection = .up
        var visitedLocations: Set<LocationPoint> = []
        while true {
            visitedLocations.insert(currentGuardPosition)
            
            let nextGuardPosition: LocationPoint
            switch guardMovingDirection {
            case .up:
                nextGuardPosition = LocationPoint(x: currentGuardPosition.x, y: currentGuardPosition.y - 1)
            case .down:
                nextGuardPosition = LocationPoint(x: currentGuardPosition.x, y: currentGuardPosition.y + 1)
            case .left:
                nextGuardPosition = LocationPoint(x: currentGuardPosition.x - 1, y: currentGuardPosition.y)
            case .right:
                nextGuardPosition = LocationPoint(x: currentGuardPosition.x + 1, y: currentGuardPosition.y)
            }
            
            guard nextGuardPosition.y >= 0,
                  nextGuardPosition.y < map.count,
                  nextGuardPosition.x >= 0,
                  nextGuardPosition.x < map[nextGuardPosition.y].count
            else { break }
                
            if map[nextGuardPosition.y][nextGuardPosition.x] == "#" {
                guardMovingDirection = guardMovingDirection.nextDirection
                continue
            }
            
            currentGuardPosition = nextGuardPosition
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(visitedLocations.count) // 5145
        
        
        // MARK: - Task 2
        
        var numberOfLoopingRoutes: Int = 0
        
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                guard map[y][x] == "." else { continue }
                
                var loopingMap = map
                loopingMap[y][x] = "O"
                
                guardMovingDirection = .up
                var currentGuardPosition2 = LocationPointWithDirection(x: guardStartPosition.x, y: guardStartPosition.y, direction: guardMovingDirection)
                
                var visitedLocations2: Set<LocationPointWithDirection> = []
                while true {
                    if visitedLocations2.contains(currentGuardPosition2) {
                        numberOfLoopingRoutes += 1
                        break
                    }
                    visitedLocations2.insert(currentGuardPosition2)
                    
                    let nextGuardPosition: LocationPoint
                    switch guardMovingDirection {
                    case .up:
                        nextGuardPosition = LocationPoint(x: currentGuardPosition2.x, y: currentGuardPosition2.y - 1)
                    case .down:
                        nextGuardPosition = LocationPoint(x: currentGuardPosition2.x, y: currentGuardPosition2.y + 1)
                    case .left:
                        nextGuardPosition = LocationPoint(x: currentGuardPosition2.x - 1, y: currentGuardPosition2.y)
                    case .right:
                        nextGuardPosition = LocationPoint(x: currentGuardPosition2.x + 1, y: currentGuardPosition2.y)
                    }
                    
                    guard nextGuardPosition.y >= 0,
                          nextGuardPosition.y < loopingMap.count,
                          nextGuardPosition.x >= 0,
                          nextGuardPosition.x < loopingMap[nextGuardPosition.y].count
                    else {
                        break
                    }
                        
                    if loopingMap[nextGuardPosition.y][nextGuardPosition.x] == "#" || loopingMap[nextGuardPosition.y][nextGuardPosition.x] == "O" {
                        guardMovingDirection = guardMovingDirection.nextDirection
                        currentGuardPosition2 = LocationPointWithDirection(x: currentGuardPosition2.x, y: currentGuardPosition2.y, direction: guardMovingDirection)
                        continue
                    }
                    
                    currentGuardPosition2 = LocationPointWithDirection(x: nextGuardPosition.x, y: nextGuardPosition.y, direction: guardMovingDirection)
                }
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(numberOfLoopingRoutes) // 1523
    }
}
