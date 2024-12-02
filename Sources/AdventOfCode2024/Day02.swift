import Foundation

struct Day2 {
    
    private static func checkLevels(_ levels: [Int]) -> Bool {
        let isIncreasing = levels[1] > levels[0]
        var previousLevel = levels[0]
        for currentLevel in levels[1...] {
            let difference = currentLevel - previousLevel
            previousLevel = currentLevel
            if difference == 0 { return false }
            if difference < 0 && isIncreasing { return false }
            if difference > 0 && !isIncreasing { return false }
            if abs(difference) > 3 { return false }
        }
        
        return true
    }
    
    
    @available(macOS 15.0, *)
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day02", ofType: "txt")!)
        let reports = input.dropLast(1).components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .whitespaces).map { Int($0)! } }
        
        
        // MARK: - Task 1
        
        let safeCount = reports.reduce(into: 0, { (sum, levels) in
            sum += checkLevels(levels) ? 1 : 0
        })
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(safeCount) // 411
        
        
        // MARK: - Task 2
        
        let safeCount2 = reports.reduce(into: 0, { (sum, levels) in
            if checkLevels(levels) {
                sum += 1
                return
            }
            for i in 0..<levels.count {
                if checkLevels(Array(levels.removingSubranges(RangeSet(i..<(i+1))))) {
                    sum += 1
                    return
                }
            }
        })
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(safeCount2) // 465
    }
}
