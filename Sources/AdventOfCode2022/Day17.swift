import Foundation

struct Day17 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let moveInstructionString = inputRows.first!
        
        var offset = 0
        let currentMoveInstruction = moveInstructionString[moveInstructionString.index(moveInstructionString.startIndex, offsetBy: offset % moveInstructionString.count)]
        
        let rocks = [
            [
                [0,0,0,0],
                [0,0,0,0],
                [0,0,0,0],
                [1,1,1,1]
            ],
            [
                [0,0,0,0],
                [0,1,0,0],
                [1,1,1,0],
                [0,1,0,0]
            ],
            [
                [0,0,0,0],
                [0,1,0,0],
                [1,1,1,0],
                [0,1,0,0]
            ],
            [
                [1,0,0,0],
                [1,0,0,0],
                [1,0,0,0],
                [1,0,0,0]
            ],
            [
                [0,0,0,0],
                [0,0,0,0],
                [1,1,0,0],
                [1,1,0,0]
            ]
        ]
        
        var map: [[Int]] = Array(repeating: Array(repeating: 0, count: 7), count: 4)
        
        func printMap() {
            for line in map.reversed() {
                print("|", terminator: "")
                print(line.reduce(into: "", { $0 += "\($1 == 1 ? "#" : ".")" }), terminator: "")
                print("|")
            }
            print("+-------+")
        }
        
        for rockIndex in 0 ..< 2022 {
            let rock = rocks[rockIndex % rocks.count]
        }
        
        printMap()
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
