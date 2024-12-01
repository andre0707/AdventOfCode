import Foundation

struct Day1 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day01", ofType: "txt")!)
        let rows = input.dropLast(1).components(separatedBy: .newlines)
        
        var leftList: [Int] = []
        var rightList: [Int] = []
        
        for row in rows {
            let components = row.components(separatedBy: "   ")
            leftList.append(Int(components[0])!)
            rightList.append(Int(components[1])!)
        }
        
        
        // MARK: - Task 1
        
        leftList.sort()
        rightList.sort()
        
        let totalDistance = zip(leftList, rightList).reduce(into: 0, { $0 += abs($1.0 - $1.1) })
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(totalDistance) // 2580760
        
        
        // MARK: - Task 2
        
        var occurrencesInRightList: [Int : Int] = [:]
        
        for number in rightList {
            occurrencesInRightList[number, default: 0] += 1
        }
        
        let similarityScore: Int = leftList.reduce(into: 0, { $0 += $1 * (occurrencesInRightList[$1] ?? 0) })
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(similarityScore) // 25358365
    }
}
