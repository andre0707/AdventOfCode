import Foundation


struct Day15 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day15", ofType: "txt")!).components(separatedBy: ",").compactMap { Int($0.replacingOccurrences(of: "\n", with: "") ) }
        
        
        func nthSpokenNumber(for n: Int, in input: [Int]) -> Int {
            var lastSpoken: [Int : Int] = input.enumerated().reduce(into: [Int : Int](), { (result, element) in result[element.1] = element.0 + 1 })
            var previousSpoken: [Int : Int] = [:]
            var lastSpokenNumber = input.last!
            
            for turn in (input.count + 1) ... n {
                if (lastSpoken[lastSpokenNumber] ?? 0) > input.count && previousSpoken[lastSpokenNumber] != nil {
                    lastSpokenNumber = lastSpoken[lastSpokenNumber]! - previousSpoken[lastSpokenNumber]!
                    if lastSpoken[lastSpokenNumber] != nil {
                        previousSpoken[lastSpokenNumber] = lastSpoken[lastSpokenNumber]
                    }
                    lastSpoken[lastSpokenNumber] = turn
                } else {
                    lastSpokenNumber = 0
                    previousSpoken[lastSpokenNumber] = lastSpoken[lastSpokenNumber]
                    lastSpoken[lastSpokenNumber] = turn
                }
            }
            
            return lastSpokenNumber
        }
        
        
        // MARK: - Task1
        
        print("The 2020th number spoken is the: \(nthSpokenNumber(for: 2020, in: input))")
        
        // MARK: - Task2
        
        print("The 30000000th number spoken is the: \(nthSpokenNumber(for: 30000000, in: input))")
        
    }
}
