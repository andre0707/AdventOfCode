import Foundation

struct Day9 {
    
    struct Position: Hashable {
        let x: Int
        let y: Int
        
        private func touches(position: Position) -> Bool {
            let dx = x - position.x
            let dy = y - position.y
            
            return abs(dx) <= 1 && abs(dy) <= 1
        }
        
        func moveInstructions(toGetCloserTo position: Position) -> (Int, Int) {
            if self.touches(position: position) { return (0, 0) }
            
            /// Need to move horizontal
            if y == position.y {
                if x > position.x { return (-1 , 0) }
                return (1, 0)
            }
            
            /// Need to move vertical
            if x == position.x {
                if y > position.y { return (0, -1) }
                return (0, 1)
            }
            
            /// Need to move diagonal
            switch (x > position.x, y > position.y) {
            case (true, true):
                return (-1, -1)
            case (true, false):
                return (-1, 1)
            case (false, true):
                return (1, -1)
            case (false, false):
                return (1, 1)
            }
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day09", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        func countTailVisitedPoitions(forTailLength: Int) -> Int {
            var headerPosition = Position(x: 0, y: 0)
            var bodyPositions = Array(repeating: Position(x: 0, y: 0), count: forTailLength)
            var tailPositions: Set<Position> = []
            
            for instruction in inputRows {
                let components = instruction.components(separatedBy: .whitespaces)
                
                for _ in 0 ..< Int(components[1])! {
                    switch components[0] {
                    case "U":
                        headerPosition = Position(x: headerPosition.x, y: headerPosition.y + 1)
                    case "D":
                        headerPosition = Position(x: headerPosition.x, y: headerPosition.y - 1)
                    case "L":
                        headerPosition = Position(x: headerPosition.x - 1, y: headerPosition.y)
                    case "R":
                        headerPosition = Position(x: headerPosition.x + 1, y: headerPosition.y)
                    default:
                        assertionFailure("unknown instruction")
                        return 0
                    }
                    
                    for tailIndex in 0 ..< bodyPositions.count {
                        
                        let (dx, dy): (Int, Int)
                        if tailIndex == 0 {
                            (dx, dy) = bodyPositions[tailIndex].moveInstructions(toGetCloserTo: headerPosition)
                        } else {
                            (dx, dy) = bodyPositions[tailIndex].moveInstructions(toGetCloserTo: bodyPositions[tailIndex - 1])
                        }
                        
                        if (dx, dy) == (0, 0) { break }
                        
                        bodyPositions[tailIndex] = Position(x: bodyPositions[tailIndex].x + dx, y: bodyPositions[tailIndex].y + dy)
                    }
                    
                    tailPositions.insert(bodyPositions.last!)
                }
            }

            return tailPositions.count
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Tail visited \(countTailVisitedPoitions(forTailLength: 1)) different positions")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Tail visited \(countTailVisitedPoitions(forTailLength: 9)) different positions")
    }
}
