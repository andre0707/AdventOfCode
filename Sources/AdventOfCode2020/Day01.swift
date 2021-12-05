import Foundation

struct Day1 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day01", ofType: "txt")!)
        let numbers = input.components(separatedBy: .newlines).compactMap { Int($0) }

        outerLoop: for number in numbers {
            let calcResult = 2020 - number
            if numbers.contains(calcResult) {
                print("result task 1: \(number) * \(calcResult) = \(number * calcResult)")
                break outerLoop
            }
        }

        let size = numbers.count
        outerLoop: for n1 in 0 ..< size {
            let number1 = numbers[n1]
            for n2 in n1 ..< size {
                let number2 = numbers[n2]
                for n3 in n2 ..< size {
                    let number3 = numbers[n3]
                    if number1 + number2 + number3 != 2020 { continue }
                    print("result task 2: \(number1) * \(number2) * \(number3) = \(number1 * number2 * number3)")
                    break outerLoop
                }
            }
        }
    }
}
