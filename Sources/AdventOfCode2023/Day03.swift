import Foundation

struct Day3 {
    
    static func numberRange(in row: String, searchStartIndex: Int) -> Range<String.Index>? {
        guard searchStartIndex >= 0, searchStartIndex < row.count else { return nil }
        var startIndex = row.index(row.startIndex, offsetBy: searchStartIndex)
        guard row[startIndex].isNumber else { return nil }
        
        var endIndex = startIndex
        
        while row[startIndex].isNumber, startIndex > row.startIndex {
            startIndex = row.index(before: startIndex)
        }
        if !row[startIndex].isNumber {
            startIndex = row.index(after: startIndex)
        }
        
        while row[endIndex].isNumber {
            let nextIndex = row.index(after: endIndex)
            endIndex = nextIndex
            if nextIndex >= row.endIndex { break }
        }
        
        return startIndex..<endIndex
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day03", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        var sum = 0
        var sumOfGearRatios = 0
        for (rowIndex, row) in inputRows.enumerated() {
            for (characterIndex, character) in row.enumerated() {
                guard !character.isNumber, character != "." else { continue }
                
                var potentialGearPartNumbers: [Int] = []
                
                func checkRow(at rowIndex: Int, characterIndex: Int) {
                    let rowToCheck = inputRows[rowIndex]
                    let rangeLeftNumber = numberRange(in: rowToCheck, searchStartIndex: characterIndex - 1)
                    if rangeLeftNumber != nil {
                        let number = Int(rowToCheck[rangeLeftNumber!])!
                        sum += number
                        potentialGearPartNumbers.append(number)
                    }
                    let rangeCenterNumber = numberRange(in: rowToCheck, searchStartIndex: characterIndex)
                    if rangeCenterNumber != nil && !(rangeLeftNumber?.overlaps(rangeCenterNumber!) ?? false) {
                        let number = Int(rowToCheck[rangeCenterNumber!])!
                        sum += number
                        potentialGearPartNumbers.append(number)
                    }
                    if rangeCenterNumber == nil {
                        if let rangeRightNumber = numberRange(in: rowToCheck, searchStartIndex: characterIndex + 1) {
                            let number = Int(rowToCheck[rangeRightNumber])!
                            sum += number
                            potentialGearPartNumbers.append(number)
                        }
                    }
                }
                
                // check top row
                if rowIndex > 0 {
                    checkRow(at: rowIndex - 1, characterIndex: characterIndex)
                }
                
                // check center row
                if let rangeLeftNumber = numberRange(in: row, searchStartIndex: characterIndex - 1) {
                    let number = Int(row[rangeLeftNumber])!
                    sum += number
                    potentialGearPartNumbers.append(number)
                }
                if let rangeRightNumber = numberRange(in: row, searchStartIndex: characterIndex + 1) {
                    let number = Int(row[rangeRightNumber])!
                    sum += number
                    potentialGearPartNumbers.append(number)
                }
                
                // check bottom row
                if rowIndex + 1 < inputRows.count {
                    checkRow(at: rowIndex + 1, characterIndex: characterIndex)
                }
                
                if character == "*" && potentialGearPartNumbers.count == 2 {
                    sumOfGearRatios += (potentialGearPartNumbers[0] * potentialGearPartNumbers[1])
                }
            }
        }
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum is: \(sum)")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The gear ratio sum is: \(sumOfGearRatios)")
    }
}
