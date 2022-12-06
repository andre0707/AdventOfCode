import Foundation

struct Day6 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day06", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        func indexOfFirstUniqueSequence(ofLength length: Int) -> Int {
            var startIndex = inputRows[0].startIndex
            var endIndex = inputRows[0].index(startIndex, offsetBy: length)
            
            while endIndex <= inputRows[0].endIndex {
                if Set(inputRows[0][startIndex..<endIndex]).count == length { break }
                startIndex = inputRows[0].index(after: startIndex)
                endIndex = inputRows[0].index(after: endIndex)
            }
            
            return inputRows[0].distance(from: inputRows[0].startIndex, to: endIndex)
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("First marker after: \(indexOfFirstUniqueSequence(ofLength: 4))")
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("First marker after: \(indexOfFirstUniqueSequence(ofLength: 14))")
    }
}
