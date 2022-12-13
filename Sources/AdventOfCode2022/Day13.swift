import Foundation

struct Day13 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day13", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines)
        
        
        func buildList(from string: String) -> [Any] {
            var string = string
            
            var result: [Any] = []
            
            var currentNumber = ""
            
            while !string.isEmpty {
                let currentChar = string.removeFirst()
                
                switch currentChar {
                case "[":
                    let endIndex = string.firstIndex(of: "]")!
                    result.append(buildList(from: String(string[string.startIndex...endIndex])))
                    
                    string.removeFirst(string.distance(from: string.startIndex, to: endIndex))
                    
                case "]":
                    if !currentNumber.isEmpty {
                        result.append(Int(currentNumber)!)
                        currentNumber = ""
                    }
                    
                case ",":
                    if !currentNumber.isEmpty {
                        result.append(Int(currentNumber)!)
                        currentNumber = ""
                    }
                    
                default:
                    currentNumber += String(currentChar)
                }
            }
            
            if !currentNumber.isEmpty {
                result.append(Int(currentNumber)!)
                currentNumber = ""
            }
            
            return result
        }
        
        
        func isFirstListSmaller(firstList: [Any], secondList: [Any]) -> Bool? {
            
            for index in 0 ..< firstList.count {
                if index >= secondList.count { return false }
                
                switch (firstList[index] is Int, secondList[index] is Int) {
                case (true, true):
                    if (firstList[index] as! Int) > (secondList[index] as! Int) { return false }
                    if (firstList[index] as! Int) < (secondList[index] as! Int) { return true }
                    continue
                    
                case (true, false):
                    if let result = isFirstListSmaller(firstList: [firstList[index]], secondList: secondList[index] as! [Any]) {
                        return result
                    }
                    continue
                    
                case (false, true):
                    if let result = isFirstListSmaller(firstList: firstList[index] as! [Any], secondList: [secondList[index]]) {
                        return result
                    }
                    continue
                    
                case (false, false):
                    if let result = isFirstListSmaller(firstList: firstList[index] as! [Any], secondList: secondList[index] as! [Any]) {
                        return result
                    }
                    continue
                }
            }
            
            if firstList.count < secondList.count { return true }
            
            return nil
        }
        
        
        
        var linesInOrder: [Int: Bool] = [:]
        var pairIndex = 0
        
        var listOfAllLines: [[Any]] = []
        
        for index in stride(from: 0, to: inputRows.count, by: 3) {
            pairIndex += 1
            
            let firstLine = buildList(from: String(inputRows[index].dropFirst().dropLast()))
            let secondLine = buildList(from: String(inputRows[index + 1].dropFirst().dropLast()))
            
            listOfAllLines.append(firstLine)
            listOfAllLines.append(secondLine)
            
            let isInOrder = isFirstListSmaller(firstList: firstLine, secondList: secondLine)
            linesInOrder[pairIndex] = isInOrder ?? false
        }
        
        
        // MARK: - Task 1
        
        
        let counterLinesInOrder = linesInOrder.reduce(into: 0, { $0 += $1.value ? $1.key : 0 })
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Sum of pairs in order: \(counterLinesInOrder)")
        
        
        // MARK: - Task 2
        
        listOfAllLines.append([[2]])
        listOfAllLines.append([[6]])
        
        listOfAllLines
            .sort(by: {
                isFirstListSmaller(firstList: $0, secondList: $1) ?? false
            })
        
        let firstIndex = listOfAllLines.firstIndex(where: {
            guard let element = $0 as? [[Int]] else { return false }
            return element == [[2]]
        })
        let secondIndex = listOfAllLines.firstIndex(where: {guard let element = $0 as? [[Int]] else { return false }
            return element == [[6]]
        })
        
        let decoderKey = (firstIndex! + 1) * (secondIndex! + 1)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Decoder key: \(decoderKey)")
    }
}
