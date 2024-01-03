import Foundation

extension Array where Element == String {
    func firstIndex(of searchElement: String, starting at: Int) -> Int? {
        self[at...].firstIndex(of: searchElement)
    }
}

let horizontal = "─"
let vertical = "│"
let downRight = "┌"
let downLeft = "┐"
let upRight = "└"
let upLeft =  "┘"


struct Day18 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day18", ofType: "txt")!)
        let inputRows = input.dropLast(1).components(separatedBy: .newlines)
        
        let digInstructions = inputRows.map { $0.components(separatedBy: .whitespaces) }
        
        // prepare dig map
        var minX = 0
        var maxX = 0
        var minY = 0
        var maxY = 0
        var currentPoint = (0, 0)
        for digInstruction in digInstructions {
            guard let distance = Int(digInstruction[1]) else {
                assertionFailure()
                continue
            }
            switch digInstruction[0] {
            case "U":
                currentPoint.1 -= distance
            case "D":
                currentPoint.1 += distance
            case "L":
                currentPoint.0 -= distance
            case "R":
                currentPoint.0 += distance
            default:
                assertionFailure()
            }
            if currentPoint.0 > maxX {
                maxX = currentPoint.0
            }
            if currentPoint.0 < minX {
                minX = currentPoint.0
            }
            if currentPoint.1 > maxY {
                maxY = currentPoint.1
            }
            if currentPoint.1 < minY {
                minY = currentPoint.1
            }
        }
        
        var digMap = Array(repeating: Array(repeating: ".", count: maxX - minX + 1), count: maxY - minY + 1)
        
        func printMap() {
            for row in digMap {
                print(row.joined())
            }
        }
        
        
        currentPoint = (abs(minX), abs(minY))
        // dig edge
        for digInstruction in digInstructions {
            guard let distance = Int(digInstruction[1]) else {
                assertionFailure()
                continue
            }
            switch digInstruction[0] {
            case "U":
                for rowIndex in currentPoint.1 - distance ... currentPoint.1 {
                    digMap[rowIndex][currentPoint.0] = vertical
                }
                currentPoint.1 -= distance
            case "D":
                for rowIndex in currentPoint.1 ... currentPoint.1 + distance {
                    digMap[rowIndex][currentPoint.0] = vertical
                }
                currentPoint.1 += distance
            case "L":
                for columnIndex in currentPoint.0 - distance ... currentPoint.0 {
                    digMap[currentPoint.1][columnIndex] = horizontal
                }
                currentPoint.0 -= distance
            case "R":
                for columnIndex in currentPoint.0 ... currentPoint.0 + distance {
                    digMap[currentPoint.1][columnIndex] = horizontal
                }
                currentPoint.0 += distance
            default:
                assertionFailure()
            }
        }
        // set corners
        for rowIndex in 0 ..< digMap.count {
            for columnIndex in 0 ..< digMap[rowIndex].count {
                guard digMap[rowIndex][columnIndex] != "." else { continue }
                
                if rowIndex > 0 && columnIndex < digMap[rowIndex].count - 1 && digMap[rowIndex][columnIndex + 1] == horizontal && digMap[rowIndex - 1][columnIndex] == vertical {
                    digMap[rowIndex][columnIndex] = upRight
                    continue
                }
                if rowIndex < digMap.count - 1 && columnIndex < digMap[rowIndex].count - 1 && digMap[rowIndex][columnIndex + 1] == horizontal && digMap[rowIndex + 1][columnIndex] == vertical {
                    digMap[rowIndex][columnIndex] = downRight
                    continue
                }
                if rowIndex > 0 && columnIndex > 0 && digMap[rowIndex][columnIndex - 1] == horizontal && digMap[rowIndex - 1][columnIndex] == vertical {
                    digMap[rowIndex][columnIndex] = upLeft
                    continue
                }
                if rowIndex < digMap.count - 1 && columnIndex > 0 && digMap[rowIndex][columnIndex - 1] == horizontal && digMap[rowIndex + 1][columnIndex] == vertical {
                    digMap[rowIndex][columnIndex] = downLeft
                    continue
                }
            }
        }
        
        // dig interior
        for (rowIndex, row) in digMap.enumerated() {
            for columnIndex in 0 ..< digMap[rowIndex].count {
                guard digMap[rowIndex][columnIndex] == "." else { continue }
                if row[..<columnIndex].filter({ [vertical, downLeft, downRight].contains($0) }).count % 2 == 1 {
                    digMap[rowIndex][columnIndex] = "#"
                }
            }
        }
//        printMap()
        
        let size = digMap.reduce(into: 0) { $0 += $1.filter { $0 != "." }.count }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("It could hold \(size) cubic meters") // 28911
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
