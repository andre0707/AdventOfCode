import Foundation

struct Day13 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day13", ofType: "txt")!)
        
        let inputPatters = input.components(separatedBy: "\n\n").map { $0.components(separatedBy: .newlines).filter { !$0.isEmpty }.map { $0.map { $0 } } }
        
        func summarizeReflectionLines(allowSmudge: Bool) -> Int {
            var sum = 0
            for patter in inputPatters {
                // horizontal symmetry  search
                for rowIndex in 0 ..< patter.count - 1 {
                    var foundErrors = 0
                    for deltaRowIndex in 0 ..< patter.count {
                        let top = rowIndex - deltaRowIndex
                        let bottom = rowIndex + 1 + deltaRowIndex
                        guard top >= 0, top < bottom, bottom < patter.count else { continue }
                        for columnIndex in 0 ..< patter[0].count {
                            if patter[top][columnIndex] != patter[bottom][columnIndex] {
                                foundErrors += 1
                            }
                        }
                    }
                    if foundErrors == (allowSmudge ? 1 : 0) {
                        sum += (rowIndex + 1) * 100
                    }
                }
                
                // vertical symmetry search
                for columnIndex in 0 ..< patter[0].count - 1 {
                    var foundErrors = 0
                    for deltaColumnIndex in 0 ..< patter[0].count {
                        let left = columnIndex - deltaColumnIndex
                        let right =  columnIndex + 1 + deltaColumnIndex
                        guard left >= 0, left < right, right < patter[0].count else { continue }
                        for rowIndex in 0 ..< patter.count {
                            if patter[rowIndex][left] != patter[rowIndex][right] {
                                foundErrors += 1
                            }
                        }
                    }
                    if foundErrors == (allowSmudge ? 1 : 0) {
                        sum += (columnIndex + 1)
                    }
                }
            }
            return sum
        }
        
        
        // MARK: - Task 1
        
        var answer = summarizeReflectionLines(allowSmudge: false)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Summarize number: \(answer)") // 29165
        
        
        // MARK: - Task 2
        
        answer = summarizeReflectionLines(allowSmudge: true)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Summarize number: \(answer)") // 32192
    }
}
