import Foundation

struct Day6 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day06", ofType: "txt")!)
        
        func calculateFish(for days: Int) -> Int {
            var counter = Array(repeating: 0, count: 9)
            
            /// Fill counter with input
            for i in 0 ... 8 {
                counter[i] = input.filter( { String($0) == "\(i)" } ).count
            }
            
            /// Loop over days
            for _ in 1 ... days {
                let oldCount0 = counter[0]
                for i in 1 ... 8 {
                    counter[i - 1] = counter[i]
                }
                counter[6] += oldCount0
                counter[8] = oldCount0
            }
            
            /// Return sum
            return counter.reduce(0, +)
        }
        
        
        // MARK: - Task 1
        
        print("There are \(calculateFish(for: 80)) fish")
        
        
        // MARK: - Task 2
        
        print("There are \(calculateFish(for: 256)) fish")
    }
}
