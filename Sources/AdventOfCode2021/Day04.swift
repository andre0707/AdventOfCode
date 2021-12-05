import Foundation

struct Day4 {
    
    struct BingoBoard {
        let boardId: Int
        private var data: [[Int]] = []
        
        init(_ data: [String], boardId: Int) {
            self.boardId = boardId
            self.data = data.compactMap {
                $0
                    .components(separatedBy: .whitespaces)
                    .compactMap { Int($0) }
            }
        }
        
        mutating func checkDrawnNumber(_ number: Int) {
            for rowIndex in 0 ..< data.count {
                for columnIndex in 0 ..< data[rowIndex].count {
                    if data[rowIndex][columnIndex] == number {
                        data[rowIndex][columnIndex] *= -1
                        if number == 0 {
                            data[rowIndex][columnIndex] = Int.min
                        }
                    }
                }
            }
        }
        
        func didBoardWin() -> Bool {
            guard !data.isEmpty else { return false }
            
            var counterCheckedCellsInColumn = Array(repeating: 0, count: data[0].count)
            for rowIndex in 0 ..< data.count {
                var counterCheckedCellsInRow = 0
                for columnIndex in 0 ..< data[rowIndex].count {
                    if data[rowIndex][columnIndex] < 0 {
                        counterCheckedCellsInRow += 1
                        counterCheckedCellsInColumn[columnIndex] += 1
                    }
                    
                    if counterCheckedCellsInColumn[columnIndex] == data.count { return true }
                }
                if counterCheckedCellsInRow == data[rowIndex].count { return true }
            }
            
            return false
        }
        
        func sumOfAllUnmarkedNumbers() -> Int {
            return data.reduce(into: 0, { (result, nextValue) in
                result += nextValue.reduce(into: 0, { (result, nextValue) in
                    if nextValue >= 0 {
                        result += nextValue
                    }
                })
            })
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day04", ofType: "txt")!)
        var lines = input.components(separatedBy: .newlines)
        
        let drawnNumbers = lines
            .removeFirst()
            .components(separatedBy: ",")
            .map { Int($0)! }
        
        lines.removeFirst()
        
        var boards = [BingoBoard]()
        
        while !lines.isEmpty {
            boards.append(BingoBoard(Array(lines.prefix(5)), boardId: boards.count))
            lines.removeFirst(6)
        }
        
        // MARK: - Task 1
        
    numbersLoop:
        for number in drawnNumbers {
            for boardIndex in boards.indices {
                boards[boardIndex].checkDrawnNumber(number)
                if boards[boardIndex].didBoardWin() {
                    
                    let sumOfAllUnmarkedNumbers = boards[boardIndex].sumOfAllUnmarkedNumbers()
                    print("winning board score: \(sumOfAllUnmarkedNumbers) * \(number) = \(sumOfAllUnmarkedNumbers * number)")
                    break numbersLoop
                }
            }
        }
        
        
        // MARK: - Task 2
        
    numbersLoop:
        for number in drawnNumbers {
            if boards.count == 1 {
                boards[0].checkDrawnNumber(number)
                if boards[0].didBoardWin() {
                    let sumOfAllUnmarkedNumbers = boards[0].sumOfAllUnmarkedNumbers()
                    print("winning board score: \(sumOfAllUnmarkedNumbers) * \(number) = \(sumOfAllUnmarkedNumbers * number)")
                    return
                } else { continue }
            }
            
            var idsToRemove: Set<Int> = []
            for boardIndex in boards.indices {
                boards[boardIndex].checkDrawnNumber(number)
                if boards[boardIndex].didBoardWin() {
                    idsToRemove.insert(boards[boardIndex].boardId)
                }
            }
            boards.removeAll { idsToRemove.contains($0.boardId)  }
        }
        
        print("no winning board")
    }
}
