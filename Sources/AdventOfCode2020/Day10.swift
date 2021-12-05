import Foundation


struct Day10 {
    static func run() {
        let inputLines = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day10", ofType: "txt")!).components(separatedBy: .newlines)
        
        let numbers = inputLines.compactMap { Int($0) }
        
        var outputJoltage = 0
        var counter = [1:0, 2:0, 3:0]
        
        while true {
            if numbers.contains(outputJoltage + 1) {
                counter[1]! += 1
                outputJoltage += 1
                continue
            }
            
            if numbers.contains(outputJoltage + 3) {
                counter[3]! += 1
                outputJoltage += 3
                continue
            }
            
            if numbers.contains(outputJoltage + 2) {
                counter[2]! += 1
                outputJoltage += 2
                continue
            }
            
            break
        }
        
        outputJoltage += 3 // final adding
        counter[3]! += 1
        
        print("Task1: The final output joltage is \(outputJoltage). It includes \(counter[1]!) differences of 1 jolt, \(counter[2]!) differences of 2 jolts and \(counter[3]!) differences of 3 jolts.\nThe 1-jolt differences multiplied with the 3-jolt differences is \(counter[1]! * counter[3]!)")
        
        
        
        
        
        func task2(numbers: [Int], numberToCheck: Int, cachedValues: inout [Int : Int], maxNumber: Int) -> Int? {
            if numberToCheck > maxNumber { return nil }
            
            if cachedValues[numberToCheck] != nil {
                return cachedValues[numberToCheck]!
            }
            
            (1 ... 3).forEach { step in
                if numbers.contains(numberToCheck + step) {
                    if let count = task2(numbers: numbers, numberToCheck: numberToCheck + step, cachedValues: &cachedValues, maxNumber: maxNumber) {
                        if cachedValues[numberToCheck] != nil {
                            cachedValues[numberToCheck]! += count
                        } else {
                            cachedValues[numberToCheck] = count
                        }
                    } else {
                        if cachedValues[numberToCheck] != nil {
                            cachedValues[numberToCheck]! += 1
                        } else {
                            cachedValues[numberToCheck] = 1
                        }
                    }
                }
            }
            
            return cachedValues[numberToCheck]
        }
        
        
        let maxNumber = numbers.max()!
        var cachedValues: [Int: Int] = [maxNumber : 1]
        let numberArragements = task2(numbers: numbers, numberToCheck: 0, cachedValues: &cachedValues, maxNumber: maxNumber) ?? 0
        print("Task2: There are \(numberArragements) arrangements to conect the charging outlet with the device.")
    }
}
