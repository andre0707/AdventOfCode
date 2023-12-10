import Foundation

fileprivate extension String {
    func at(_ index: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: index)]
    }
}

struct Day10 {
    
    struct Position: Hashable {
        let x: Int
        let y: Int
        
        var leftNeighbour: Position { Position(x: x - 1, y: y) }
        var rightNeighbour: Position { Position(x: x + 1, y: y) }
        var topNeighbour: Position { Position(x: x, y: y - 1) }
        var bottomNeighbour: Position { Position(x: x, y: y + 1) }
    }
    
    struct Field {
        private let pipeMap: [[Character]]
        private let startPosition: Position
        private let startPositionPipeType: Character
        
        private var lastPosition: Position
        private var currentPosition: Position
        var positionsInLoop: Set<Position> = []
        
        var isAtStartPosition: Bool { currentPosition == startPosition }
        
        init(rows: [String]) {
            pipeMap = rows.map { $0.map { $0 } }
            
            let startPosition = {
                for (rowIndex, row) in rows.enumerated() {
                    for (columnIndex, char) in row.enumerated() {
                        if char == "S" {
                            return Position(x: columnIndex, y: rowIndex)
                        }
                    }
                }
                return Position(x: 0, y: 0)
            }()
            self.startPosition = startPosition
            lastPosition = startPosition
            positionsInLoop.insert(startPosition)
            
            startPositionPipeType = {
                var continiousOnLeft = false
                var continiousOnRight = false
                var possibleValues: [Character] = ["-", "L", "F"]
                if startPosition.x > 0 && possibleValues.contains(rows[startPosition.y].at(startPosition.x - 1)) {
                    // continious on left
                    continiousOnLeft = true
                }
                possibleValues = ["-", "J", "7"]
                if possibleValues.contains(rows[startPosition.y].at(startPosition.x + 1)) {
                    // continious on right
                    if continiousOnLeft { return "-" }
                    continiousOnRight = true
                }
                possibleValues = ["|", "7", "F"]
                if startPosition.y > 0, possibleValues.contains(rows[startPosition.y - 1].at(startPosition.x)) {
                    // continious on top
                    if continiousOnLeft { return "J" }
                    if continiousOnRight { return "L" }
                }
                possibleValues = ["|", "L", "J"]
                if possibleValues.contains(rows[startPosition.y + 1].at(startPosition.x)) {
                    // continious on bottom
                    if continiousOnLeft { return "7" }
                    if continiousOnRight { return "F" }
                    return "|"
                }
                assertionFailure()
                return "."
            }()
            
            switch startPositionPipeType {
            case "-", "J", "7":
                currentPosition = startPosition.leftNeighbour
            case "|", "L":
                currentPosition = startPosition.topNeighbour
            case "F":
                currentPosition = startPosition.rightNeighbour
            default:
                currentPosition = startPosition
            }
            positionsInLoop.insert(currentPosition)
        }
        
        @discardableResult
        mutating func moveToNextPosition() -> Position {
            let lastCurrentPosition = self.currentPosition
            
            let currentPipeType = currentPosition == startPosition ? startPositionPipeType : pipeMap[currentPosition.y][currentPosition.x]
            switch currentPipeType {
            case "|": // north-south
                let deltaY = currentPosition.y < lastPosition.y ? -1 : 1
                currentPosition = Position(x: currentPosition.x, y: currentPosition.y + deltaY)
            case "-": // east-west
                let deltaX = currentPosition.x < lastPosition.x ? -1 : 1
                currentPosition = Position(x: currentPosition.x + deltaX, y: currentPosition.y)
            case "L": // north-east
                if currentPosition.y == lastPosition.y {
                    currentPosition = Position(x: currentPosition.x, y: currentPosition.y - 1)
                } else {
                    currentPosition = Position(x: currentPosition.x + 1, y: currentPosition.y)
                }
            case "J": // north-west
                if currentPosition.y == lastPosition.y {
                    currentPosition = Position(x: currentPosition.x, y: currentPosition.y - 1)
                } else {
                    currentPosition = Position(x: currentPosition.x - 1, y: currentPosition.y)
                }
            case "7": // south-west
                if currentPosition.y == lastPosition.y {
                    currentPosition = Position(x: currentPosition.x, y: currentPosition.y + 1)
                } else {
                    currentPosition = Position(x: currentPosition.x - 1, y: currentPosition.y)
                }
            case "F": // south-east
                if currentPosition.y == lastPosition.y {
                    currentPosition = Position(x: currentPosition.x, y: currentPosition.y + 1)
                } else {
                    currentPosition = Position(x: currentPosition.x + 1, y: currentPosition.y)
                }
            default:
                assertionFailure()
                return Position(x: 0, y: 0)
            }
            
            self.lastPosition = lastCurrentPosition
            return currentPosition
        }
    }
      
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day10", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        var field = Field(rows: inputRows)
        
        
        // MARK: - Task 1
        
        while true {
            let nextPosition = field.moveToNextPosition()
            if field.positionsInLoop.contains(nextPosition) { break }
            field.positionsInLoop.insert(nextPosition)
        }
        let maxValue = field.positionsInLoop.count / 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The farthest position is \(maxValue) steps away") // 6831
        
        
        // MARK: - Task 2
        
        let allowedCharacters: [Character] = ["J", "|", "L"] // only the tiles which cover the way on the top third of the tile count as crossed tiles
        var counterEnclosedTiles = 0
        for (rowIndex, row) in inputRows.enumerated() {
            var crossedPipes = 0
            for (index, char) in row.enumerated() {
                let charToCheck = field.positionsInLoop.contains(Position(x: index, y: rowIndex)) ? char : "."
                switch charToCheck {
                case "-", "J", "7", "|", "L", "F", "S": continue
                case ".":
                    var indexToCheck = index - 1
                    while indexToCheck >= 0 {
                        if allowedCharacters.contains(row.at(indexToCheck)) {
                            if field.positionsInLoop.contains(Position(x: indexToCheck, y: rowIndex)) {
                                crossedPipes += 1
                            }
                        }
                        indexToCheck -= 1
                    }
                    
                    if crossedPipes % 2 == 1 {
                        counterEnclosedTiles += 1
                    }
                    crossedPipes = 0
                    
                default:
                    assertionFailure()
                }
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("There are \(counterEnclosedTiles) tiles enclosed by the loop") // 305
    }
}
