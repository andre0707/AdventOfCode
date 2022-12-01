import Foundation

struct Day1 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day01", ofType: "txt")!)
        let numbers = input.components(separatedBy: "\n\n").compactMap { lines in
            lines.components(separatedBy: .newlines ).compactMap { Int($0) }
        }
        guard numbers.count > 0 else { return }
        
        
        let calories = numbers.map { $0.reduce(0, +) }
            .sorted { $0 > $1 }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\nThe maximum is \(calories.first!) calories")
        
        
        // MARK: - Task 2
        
        let sumOfTopThree = calories.prefix(3).reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\nThe maximum is \(sumOfTopThree) calories")
    }
}
