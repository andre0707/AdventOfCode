import Foundation

struct Day13 {
    
    class Pattern {
        private var data: [[Character]]
        
        private var rowCount: Int { data.count }
        private var columnCount: Int { data[0].count }
        
        init(patternString: String) {
            data = patternString.components(separatedBy: .newlines).filter { !$0.isEmpty }.map { $0.map { $0} }
        }
        
        func print() {
            for row in data {
                Swift.print(row.map { String($0) }.joined())
            }
        }
        
        private func row(at index: Int) -> String {
            String(data[index])
        }
        
        private func column(at index: Int) -> String {
            var result = ""
            for rowIndex in 0 ..< data.count {
                result.append(data[rowIndex][index])
            }
            return result
        }
        
        func horizontalReflectionIndex() -> Int? {
            for rowIndex in 0 ..< rowCount - 1 {
                let currentRow = row(at: rowIndex)
                let nextRow = row(at: rowIndex + 1)
                guard currentRow == nextRow else { continue }
                // potential line of reflection. Compare previous rows with next rows
                var doesMatch = true
                for index in (0 ..< rowIndex).reversed() {
                    let otherIndex = rowIndex + 1 + (rowIndex - index)
                    guard otherIndex < rowCount else { break }
                    if row(at: index) != row(at: otherIndex) {
                        doesMatch = false
                        break
                    }
                }
                if doesMatch {
                    return (rowIndex + 1) * 100 // +1, because the row numbers start at 1, not 0 like the index
                }
            }
            return nil
        }
        
        func verticalReflectionIndex() -> Int? {
            for columnIndex in 0 ..< columnCount - 1 {
                let currentColumn = column(at: columnIndex)
                let nextColumn = column(at: columnIndex + 1)
                guard currentColumn == nextColumn else { continue }
                // potential line of reflection. Compare previous columns with next columns
                var doesMatch = true
                for index in (0 ..< columnIndex).reversed() {
                    let otherIndex = columnIndex + 1 + (columnIndex - index)
                    guard otherIndex < columnCount else { break }
                    if column(at: index) != column(at: otherIndex) {
                        doesMatch = false
                        break
                    }
                }
                if doesMatch {
                    return (columnIndex + 1) // +1, because the row numbers start at 1, not 0 like the index
                }
            }
            return nil
        }
        

//        private var foundSmugedCoordiantes = false
//        private var smudgeCoordines: (Int, Int)? = nil
//        
//        func rowsDifferenceIndex(rowIndex1: Int, rowIndex2: Int) -> Int? {
//            var differenceIndicies: [Int] = []
//            for columnIndex in 0 ..< columnCount {
//                if data[rowIndex1][columnIndex] != data[rowIndex2][columnIndex] {
//                    differenceIndicies.append(columnIndex)
//                }
//            }
//            return differenceIndicies.count == 1 ? differenceIndicies[0] : nil
//        }
//        
//        func columnsDifferenceIndex(columnIndex1: Int, columnIndex2: Int) -> Int? {
//            var differenceIndicies: [Int] = []
//            for rowIndex in 0 ..< rowCount {
//                if data[rowIndex][columnIndex1] != data[rowIndex][columnIndex2] {
//                    differenceIndicies.append(rowIndex)
//                }
//            }
//            return differenceIndicies.count == 1 ? differenceIndicies[0] : nil
//        }
//        
//        func horizontalReflectionIndexAllowingSmudge() -> Int? {
//            
//            for rowIndex in 0 ..< rowCount - 1 {
//                if smudgeCoordines == nil, let columnIndexInRows = rowsDifferenceIndex(rowIndex1: rowIndex, rowIndex2: rowIndex + 1) {
//                    let flippedChar: Character = data[rowIndex][columnIndexInRows] == "." ? "#" : "."
//                    data[rowIndex][columnIndexInRows] = flippedChar
//                    smudgeCoordines = (rowIndex, columnIndexInRows)
//                }
//                let currentRow = row(at: rowIndex)
//                let nextRow = row(at: rowIndex + 1)
//                guard currentRow == nextRow else { continue }
//                // potential line of reflection. Compare previous rows with next rows
//                var doesMatch = true
//                for index in (0 ..< rowIndex).reversed() {
//                    let otherIndex = rowIndex + 1 + (rowIndex - index)
//                    guard otherIndex < rowCount else { break }
//                    if row(at: index) == row(at: otherIndex) { continue }
//                    if smudgeCoordines == nil, let columnIndexInRows = rowsDifferenceIndex(rowIndex1: index, rowIndex2: otherIndex) {
//                        let flippedChar: Character = data[rowIndex][columnIndexInRows] == "." ? "#" : "."
//                        data[rowIndex][columnIndexInRows] = flippedChar
//                        smudgeCoordines = (rowIndex, columnIndexInRows)
//                        continue
//                    }
//                    doesMatch = false
//                    if let smudgeCoordines {
//                        let flippedChar: Character = data[smudgeCoordines.0][smudgeCoordines.1] == "." ? "#" : "."
//                        data[smudgeCoordines.0][smudgeCoordines.1] = flippedChar
//                        self.smudgeCoordines = nil
//                    }
//                    break
//                }
//                if doesMatch {
//                    return (rowIndex + 1) * 100 // +1, because the row numbers start at 1, not 0 like the index
//                }
//            }
//            return nil
//        }
//        
//        func verticalReflectionIndexAllowingSmudge() -> Int? {
//            for columnIndex in 0 ..< columnCount - 1 {
//                if smudgeCoordines == nil, let rowIndexInColumns = columnsDifferenceIndex(columnIndex1: columnIndex, columnIndex2: columnIndex + 1) {
//                    let flippedChar: Character = data[rowIndexInColumns][columnIndex] == "." ? "#" : "."
//                    data[rowIndexInColumns][columnIndex] = flippedChar
//                    smudgeCoordines = (rowIndexInColumns, columnIndex)
//                }
//                let currentColumn = column(at: columnIndex)
//                let nextColumn = column(at: columnIndex + 1)
//                guard currentColumn == nextColumn else { continue }
//                // potential line of reflection. Compare previous columns with next columns
//                var doesMatch = true
//                for index in (0 ..< columnIndex).reversed() {
//                    let otherIndex = columnIndex + 1 + (columnIndex - index)
//                    guard otherIndex < columnCount else { break }
//                    if column(at: index) == column(at: otherIndex) { continue }
//                    if smudgeCoordines == nil, let rowIndexInColumns = columnsDifferenceIndex(columnIndex1: index, columnIndex2: otherIndex) {
//                        let flippedChar: Character = data[rowIndexInColumns][index] == "." ? "#" : "."
//                        data[rowIndexInColumns][index] = flippedChar
//                        smudgeCoordines = (rowIndexInColumns, index)
//                        continue
//                    }
//                    doesMatch = false
//                    if let smudgeCoordines {
//                        let flippedChar: Character = data[smudgeCoordines.0][smudgeCoordines.1] == "." ? "#" : "."
//                        data[smudgeCoordines.0][smudgeCoordines.1] = flippedChar
//                        self.smudgeCoordines = nil
//                    }
//                    break
//                }
//                if doesMatch {
//                    return (columnIndex + 1) // +1, because the row numbers start at 1, not 0 like the index
//                }
//            }
//            return nil
//        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day13", ofType: "txt")!)
        
        let patterns = input.components(separatedBy: "\n\n").map { Pattern(patternString: $0) }
        
        
        // MARK: - Task 1
        
        var reflections: [Int] = []
        for pattern in patterns {
            if let horizontalIndex = pattern.horizontalReflectionIndex() {
                reflections.append(horizontalIndex)
            } else if let verticalIndex = pattern.verticalReflectionIndex() {
                reflections.append(verticalIndex)
            } else {
                assertionFailure()
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Summarize number: \(reflections.reduce(0, +))") // 29165
        
        
        // MARK: - Task 2
        
        reflections = []
//        for (index, pattern) in patterns.enumerated() {
//            if let horizontalIndex = pattern.horizontalReflectionIndexAllowingSmudge() {
//                reflections.append(horizontalIndex)
//            } else if let verticalIndex = pattern.verticalReflectionIndexAllowingSmudge() {
//                reflections.append(verticalIndex)
//            } else {
//                pattern.print()
//                assertionFailure()
//            }
//        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Summarize number: \(reflections.reduce(0, +))") //
        // 34834 is too heigh
        // 34723 is too heigh
        // 34710 is not correct
        // 37702 is not correct
    }
}
