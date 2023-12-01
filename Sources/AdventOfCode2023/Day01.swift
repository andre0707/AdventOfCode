import Foundation

struct Day1 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day01", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let transformClosure: (String) -> Int? = {
            guard let firstFigure = $0.first(where: { $0.isNumber }),
                  let lastFigure = $0.last(where: { $0.isNumber })
            else { return nil }
            return Int(String(firstFigure) + String(lastFigure))
        }
        
        
        // MARK: - Task 1
        
        var numbers: [Int] = inputRows.compactMap(transformClosure)
        
        var sumOfNumbers = numbers.reduce(0, +)
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum is: \(sumOfNumbers)")
        
        
        // MARK: - Task 2
        
        let mappingList = [
            "one" : "o1e",
            "two" : "t2o",
            "three" : "t3e",
            "four" : "f4r",
            "five" : "f5e",
            "six" : "s6x",
            "seven" : "s7n",
            "eight" : "e8t",
            "nine" : "n9e"
        ]
        
        var replacedInput = input
        for mapping in mappingList {
            replacedInput = replacedInput.replacingOccurrences(of: mapping.key, with: mapping.value)
        }
        
        numbers = replacedInput.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .compactMap(transformClosure)
        
        sumOfNumbers = numbers.reduce(0, +)
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The sum is: \(sumOfNumbers)")
    }
}
