import Foundation

struct Day7 {
    
    enum Operator {
        case add
        case multiply
        case concatenation
    }
    
    struct OperatorQueue {
        init(length: Int, supportsConcatenation: Bool) {
            operators = Array(repeating: .add, count: length)
            self.supportsConcatenation = supportsConcatenation
        }
        
        mutating func increase() -> Bool {
            if operators.allSatisfy({ $0 == (supportsConcatenation ? .concatenation : .multiply)}) { return false }
            
            outer: for index in 0..<operators.count {
                switch operators[index] {
                case .add:
                    operators[index] = .multiply
                    break outer
                case .multiply:
                    if supportsConcatenation {
                        operators[index] = .concatenation
                        break outer
                    } else {
                        operators[index] = .add
                    }
                case .concatenation:
                    operators[index] = .add
                }
            }
            
            return true
        }
        
        private(set) var operators: [Operator]
        private let supportsConcatenation: Bool
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day07", ofType: "txt")!)
        let equationLines = input.dropLast(1).components(separatedBy: .newlines)
        
        func checkEquations(supportsConcatenation: Bool) -> Int {
            var totalCalibrationResult = 0
            
            for equation in equationLines {
                let components = equation.components(separatedBy: ": ")
                let expectedResult = Int(components[0])!
                let values = components[1].components(separatedBy: " ").map { Int($0)! }
                
                var opertorQueue = OperatorQueue(length: values.count - 1, supportsConcatenation: supportsConcatenation)
                
                outer: while true {
                    var result = values[0]
                    var operators = opertorQueue.operators
                    for value in values.dropFirst() {
                        switch operators.removeLast() {
                        case .add: result += value
                        case .multiply: result *= value
                        case .concatenation: result = Int("\(result)" + "\(value)")!
                        }
                        if result > expectedResult { break outer }
                    }
                    if result == expectedResult {
                        totalCalibrationResult += result
                        break
                    }
                    
                    if !opertorQueue.increase() { break }
                }
            }
            
            return totalCalibrationResult
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(checkEquations(supportsConcatenation: false)) // 1260333054159
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(checkEquations(supportsConcatenation: true)) // 162042343638683
    }
}
