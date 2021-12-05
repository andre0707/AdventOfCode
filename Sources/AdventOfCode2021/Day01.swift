import Foundation

struct Day1 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day01", ofType: "txt")!)
        let numbers = input.components(separatedBy: .newlines).compactMap { Int($0) }
        guard numbers.count > 0 else { return }
        
        func calculateSum(for windowWidth: Int) {
            guard windowWidth > 0,
                  numbers.count >= windowWidth
            else { return }
            
            var sumArray: [Int] = []
            var startIndex = 0
            
            if windowWidth == 1 {
                sumArray = numbers
            } else {
                while startIndex + windowWidth <= numbers.count {
                    let value = numbers[startIndex ..< startIndex + windowWidth].reduce(0, +)
                    sumArray.append(value)
                    startIndex += 1
                }
            }
            
            var countIncreased = 0
            var lastNumber = sumArray.removeFirst()
            for number in sumArray {
                if number > lastNumber {
                    countIncreased += 1
                }
                lastNumber = number
            }
            print("Window width: \(windowWidth)")
            print("Increased: \(countIncreased)\n")
        }
        
        calculateSum(for: 1)
        calculateSum(for: 3)
    }
}
