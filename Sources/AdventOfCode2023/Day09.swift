import Foundation

struct Day9 {
    
    static func differences(in array: [Int]) -> [Int] {
        var differences: [Int] = []
        for index in 0 ..< array.count - 1 {
            differences.append(array[index + 1] - array[index])
        }
        return differences
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day09", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let history = inputRows.map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        
        
        // MARK: - Task 1
        
        var extrapolatedValues: [Int] = []
        for entry in history {
            var steps: [[Int]] = []
            
            var differences = entry
            while !differences.allSatisfy( { $0 == 0 } ) {
                differences = Day9.differences(in: differences)
                steps.append(differences)
            }
            steps[steps.count - 1].append(0)
            
            for index in (0 ..< steps.count - 1).reversed() {
                steps[index].append(steps[index].last! + steps[index + 1].last!)
            }
            extrapolatedValues.append(entry.last! + steps[0].last!)
        }
        
        var sum = extrapolatedValues.reduce(0, +)
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum of the extrapolated values is: \(sum)") // 1581679977
        
        
        // MARK: - Task 2
        
        extrapolatedValues = []
        for entry in history {
            var steps: [[Int]] = []
            
            var differences = entry
            while !differences.allSatisfy( { $0 == 0 } ) {
                differences = Day9.differences(in: differences)
                steps.append(differences)
            }
            steps[steps.count - 1].insert(0, at: 0)
            
            for index in (0 ..< steps.count - 1).reversed() {
                steps[index].insert(steps[index].first! - steps[index + 1].first!, at: 0)
            }
            extrapolatedValues.insert(entry.first! - steps[0].first!, at: 0)
        }
        
        sum = extrapolatedValues.reduce(0, +)
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The sum of the extrapolated values is: \(sum)") // 889
    }
}
