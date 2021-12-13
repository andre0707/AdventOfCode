import Foundation

struct Day13 {
    
    static func printPretty(_ value: [[Int]]) {
        for row in 0 ..< value.count {
            print(value[row].reduce(into: "", { (result, nextValue) in
                result += "\(nextValue == 1 ? "#" : ".")"
            }))
        }
        print("\n\n")
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day13", ofType: "txt")!)
            .components(separatedBy: "\n\n")
        
        guard input.count > 1 else { return }
        
        let listOfDots = input[0]
            .components(separatedBy: .newlines)
            .map { element -> (Int, Int) in
                let components = element.components(separatedBy: ",")
                return (Int(components[0])!, Int(components[1])!)
            }
        
        let maxX = listOfDots.max(by: { $0.0 < $1.0 })!.0
        let maxY = listOfDots.max(by: { $0.1 < $1.1 })!.1
        
        var dotsMap: [[Int]] = Array(repeating: Array(repeating: 0, count: maxX + 1), count: maxY + 1)
        
        for dot in listOfDots {
            dotsMap[dot.1][dot.0] = 1
        }
        
        let foldInstructions = input[1]
            .components(separatedBy: .newlines)
            .compactMap { element -> (String, Int)? in
                guard !element.isEmpty else { return nil }
                let components = element.components(separatedBy: "=")
                return (String(components[0].last!), Int(components[1])!)
            }
        
        
        func fold(_ startingMap: [[Int]], foldInstructions: ArraySlice<(String, Int)>, printSteps: Bool = false) -> [[Int]] {
            var workingMap = startingMap
            for foldInstruction in foldInstructions {
                switch foldInstruction.0 {
                case "x":
                    for row in 0 ..< workingMap.count {
                        for sourceColumnIndex in foldInstruction.1 + 1 ..< workingMap[row].count {
                            let destinationColumnIndex = workingMap[row].count - 1 - sourceColumnIndex
                            
                            workingMap[row][destinationColumnIndex] |= workingMap[row][sourceColumnIndex]
                        }
                        workingMap[row].removeLast(workingMap[row].count - foldInstruction.1)
                        
                    }
                    
                case "y":
                    for sourceRowIndex in foldInstruction.1 + 1 ..< workingMap.count {
                        let destinationRowIndex = workingMap.count - 1 - sourceRowIndex
                        
                        for columnIndex in 0 ..< workingMap[sourceRowIndex].count {
                            workingMap[destinationRowIndex][columnIndex] |= workingMap[sourceRowIndex][columnIndex]
                        }
                    }
                    
                    workingMap.removeLast(workingMap.count - foldInstruction.1)
                    
                default:
                    break
                }
                
                if printSteps {
                    printPretty(workingMap)
                }
            }
            
            return workingMap
        }
        
        
        // MARK: - Task 1
        
        let visibleDots = fold(dotsMap, foldInstructions: foldInstructions[0 ..< 1])
            .reduce(into: 0, { (result, next) in
                result += next.reduce(0, +)
            })
        print("There are \(visibleDots) visible dots")
        
        
        // MARK: - Task 2
        
        let result = fold(dotsMap, foldInstructions: foldInstructions[...])
        printPretty(result)
    }
}

