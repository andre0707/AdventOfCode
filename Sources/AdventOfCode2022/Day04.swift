import Foundation

struct Day4 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day04", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let ranges = inputRows.map {
            let elfs = $0.components(separatedBy: ",")
            
            let elf1 = elfs[0].components(separatedBy: "-")
            let elf2 = elfs[1].components(separatedBy: "-")
            
            return (Int(elf1[0])!...Int(elf1[1])!, Int(elf2[0])!...Int(elf2[1])!)
        }
        
        
        // MARK: - Task 1
        
        let pairsCount = ranges.filter {
            ($0.0.lowerBound <= $0.1.lowerBound && $0.0.upperBound >= $0.1.upperBound) ||
            ($0.1.lowerBound <= $0.0.lowerBound && $0.1.upperBound >= $0.0.upperBound)
        }
            .count
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("There are \(pairsCount) pairs which contain each other")
        
        
        // MARK: - Task 2
        
        let pairsCount2 = ranges.filter {
            ($0.0.upperBound >= $0.1.lowerBound && $0.0.upperBound <= $0.1.upperBound) || ($0.1.upperBound <= $0.0.upperBound && $0.1.upperBound >= $0.0.lowerBound)
        }
            .count
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("There are \(pairsCount2) pairs which overlap")
    }
}
