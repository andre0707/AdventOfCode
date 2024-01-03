import Foundation

struct Day16 {
    
    enum BeamDirection {
        case up
        case down
        case left
        case right
    }
    
    struct Point {
        var x: Int
        var y: Int
    }
    
    struct Layout {
        let grid: [[Character]]
        
        init(from string: [String]) {
            self.grid = string.map { $0.map { $0 } }
            self.energizedLevel = Array(repeating: Array(repeating: 0, count: grid[0].count), count: grid.count)
        }
        
        var energizedLevel: [[Int]]
        
        var totalCountOfEnergizedTiles: Int {
            energizedLevel.reduce(into: 0) { partialResult, nextValue in
                partialResult += nextValue.filter { $0 > 0 }.count
            }
        }
        
        func printEnergizedGrid() {
            for row in energizedLevel {
                print(row.map { $0 > 0 ? "#" : "." }.joined())
            }
        }
        
        mutating func start(from startPosition: Point, in direction: BeamDirection) {
            var currentPosition = startPosition
            var currentDirection = direction
            
            while true {
                guard currentPosition.y >= 0, currentPosition.y < grid.count else { return }
                guard currentPosition.x >= 0, currentPosition.x < grid[currentPosition.y].count else { return }
                
                energizedLevel[currentPosition.y][currentPosition.x] += 1
                
                switch grid[currentPosition.y][currentPosition.x] {
                case ".":
                    switch currentDirection {
                    case .up:
                        currentPosition.y -= 1
                    case .down:
                        currentPosition.y += 1
                    case .left:
                        currentPosition.x -= 1
                    case .right:
                        currentPosition.x += 1
                    }
                case "/":
                    switch currentDirection {
                    case .up:
                        currentPosition.x -= 1
                        currentDirection = .right
                    case .down:
                        currentPosition.x += 1
                        currentDirection = .left
                    case .left:
                        currentPosition.y += 1
                        currentDirection = .down
                    case .right:
                        currentPosition.y -= 1
                        currentDirection = .up
                    }
                case "\\":
                    switch currentDirection {
                    case .up:
                        currentPosition.x += 1
                        currentDirection = .left
                    case .down:
                        currentPosition.x -= 1
                        currentDirection = .right
                    case .left:
                        currentPosition.y += 1
                        currentDirection = .up
                    case .right:
                        currentPosition.y -= 1
                        currentDirection = .down
                    }
                case "-":
                    switch currentDirection {
                    case .up, .down:
                        start(from: Point(x: currentPosition.x - 1, y: currentPosition.y), in: .left)
                        currentPosition.x += 1
                        currentDirection = .right
                    case .left:
                        currentPosition.x -= 1
                    case .right:
                        currentPosition.x += 1
                    }
                case "|":
                    switch currentDirection {
                    case .left, .right:
                        start(from: Point(x: currentPosition.x, y: currentPosition.y - 1), in: .up)
                        currentPosition.y += 1
                        currentDirection = .down
                    case .up:
                        currentPosition.y -= 1
                    case .down:
                        currentPosition.y += 1
                    }
                default:
                    assertionFailure()
                    return
                }
            }
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        
        var layout = Layout(from: input.dropLast(1).components(separatedBy: .newlines))
        
        layout.start(from: Point(x: 0, y: 0), in: .right)
        
        
        layout.printEnergizedGrid()
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("There are \(layout.totalCountOfEnergizedTiles) energized tiles")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
