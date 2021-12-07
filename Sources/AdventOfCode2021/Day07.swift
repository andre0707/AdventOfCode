import Foundation

struct Day7 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day07", ofType: "txt")!)
            .replacingOccurrences(of: "\n", with: "")
        
        let positions = input
            .components(separatedBy: ",")
            .map { Int($0)! }
        
        
        // MARK: - Task 1
        
        func calculateFuel(to horizontalPosition: Int) -> Int {
            var fuel = 0
            for position in positions {
                fuel += abs(horizontalPosition - position)
            }
            return fuel
        }
        
        let fuels = Set(positions).map { (pos: $0, fuel: calculateFuel(to: $0)) }
        let min = fuels.min { $0.fuel < $1.fuel }!
        print("pos: \(min.pos), value: \(min.fuel)")
        
        /// Task1 alternative via median
        /*
        let sorted = positions.sorted()
        let index = positions.count / 2
        let pos: Int
        if positions.count % 2 == 0 {
            pos = Int((0.5 * Double(sorted[index] + sorted[index + 1])).rounded(.down))
        } else {
            pos = sorted[index]
        }
        print("pos: \(pos), value: \(calculateFuel(to: pos))")
         */
        
        
        // MARK: - Task 2
        
        let average = Double(positions.reduce(0, +)) / Double(positions.count)
        
        func calculateFuel2(to horizontalPosition: Int) -> Int {
            var fuel = 0
            for position in positions {
                fuel += (0 ... abs(horizontalPosition - position)).reduce(0, +)
            }
            return fuel
        }
        
        let num1 = Int(average.rounded(.down))
        let result1 = (pos: num1, fuel: calculateFuel2(to: num1))
        let num2 = Int(average.rounded(.up))
        let result2 = (pos: num2, fuel: calculateFuel2(to: num2))
        print("pos: \(result1.fuel < result2.fuel ? result1.pos : result2.pos), value: \(result1.fuel < result2.fuel ? result1.fuel : result2.fuel)")
    }
}
