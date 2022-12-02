import Foundation

struct Day15 {
    typealias Position = (x: Int, y: Int)
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
            .components(separatedBy: .newlines)
        
        let riskMap = input
            .map {
                $0.compactMap {
                    $0.wholeNumberValue
                }
            }
        let endPosition: Position = (x: riskMap[riskMap.count - 1].count - 1, y: riskMap.count - 1)
        
        func isValidPosition(_ position: Position) -> Bool {
            guard position.y < riskMap.count,
                  position.x < riskMap[position.y].count
            else { return false }
            
            return true
        }
        
        func value(for position: Position) -> Int {
            return riskMap[position.y][position.x]
        }
        
        var position: Position = (x: 0, y: 0)
        var totalRisk = 0
        while position.x < endPosition.x && position.y < endPosition.y {
            
            
        }
        
        
        // MARK: - Task 1
        
        print("Total risk: \(totalRisk)")
        
        
        // MARK: - Task 2
    }
}
