import Foundation

struct Day3 {
    
    @available(macOS 13.0, *)
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day03", ofType: "txt")!)
        
        
        // MARK: - Task 1
        
        var result: Int = 0
        let ranges = input.ranges(of: try! Regex(#"mul\(\d+,\d+\)"#))
        for range in ranges {
            let components = input[range].components(separatedBy: ",")
            result += Int(components[0].filter(\.isNumber))! * Int(components[1].filter(\.isNumber))!
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(result) // 161085926
        
        
        // MARK: - Task 2
        
        var result2: Int = 0
        var doMultiplication = true
        let ranges2 = input.ranges(of: try! Regex(#"(mul\(\d+,\d+\))|(do\(\))|(don\'t\(\))"#))
        for range in ranges2 {
            let function = input[range]
            if function == "don't()" {
                doMultiplication = false
                continue
            }
            if function == "do()" {
                doMultiplication = true
                continue
            }
            
            guard doMultiplication else { continue }
            let components = function.components(separatedBy: ",")
            result2 += Int(components[0].filter(\.isNumber))! * Int(components[1].filter(\.isNumber))!
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(result2) // 82045421
    }
}
