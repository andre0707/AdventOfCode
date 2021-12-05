import Foundation

extension Collection where Element : Numeric {
    
    func includesElement(WhereSumIs sum: Element) -> Bool {
        for element in self {
            let elementNeeded = (sum - element)
            if elementNeeded == element { continue }
            
            if self.contains(elementNeeded) { return true }
        }
        
        return false
    }
}

struct Day9 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day09", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let inputNumbers = inputLines.compactMap { Int($0) }
        
        let preamble = 25
        
        func task1(inputNumbers: [Int], preamble: Int) -> Int? {
            var workingArray: [Int] = []
            
            for number in inputNumbers {
                if workingArray.count < preamble {
                    workingArray.append(number)
                    continue
                }
                
                if !workingArray.includesElement(WhereSumIs: number) {
                    return number
                }
                workingArray.removeFirst()
                workingArray.append(number)
            }
            
            return nil
        }
        
        let invalidNumber = task1(inputNumbers: inputNumbers, preamble: preamble) ?? 0
        print("Part1: \(invalidNumber) is not the sum of any 2 other numbers in the \(preamble) previous numbers")
        
        
        func task2(inputNumbers: [Int], checkForSum: Int) -> Int? {
            var workingArray: [Int] = []
            
            var numbersAdded = 0
            for number in inputNumbers {
                numbersAdded += number
                workingArray.append(number)
                
                if numbersAdded < checkForSum { continue }
                
                while numbersAdded > checkForSum {
                    numbersAdded -= workingArray.first!
                    workingArray.removeFirst()
                }
                
                if numbersAdded == checkForSum {
                    //done
                    guard let minValue = workingArray.min() else { return nil }
                    guard let maxValue = workingArray.max() else { return nil }
                    return  minValue + maxValue
                }
            }
            
            return nil
        }
        
        
        let resultTask2 = task2(inputNumbers: inputNumbers, checkForSum: invalidNumber) ?? 0
        print("Part2: The sum of the highest and lowest number in the contiguous interval adding up to \(invalidNumber) is: \(resultTask2)")
        
        print("done")
    }
}
