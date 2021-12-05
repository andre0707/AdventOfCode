import Foundation



func calculate(operations: [String], useNewRules: Bool = false) -> Int {
    if operations.isEmpty { return 0 }
    if operations.filter({ ($0.first?.isNumber ?? false) }).isEmpty { return 0 }
    
    var i = 0
    var leftNumber: Int? = nil
    var rightNumber: Int? = nil
    var nextOperation: String? = nil
    while i < operations.count {
        let operation = operations[i]
        
        if operation.first?.isNumber ?? false {
            if leftNumber == nil {
                leftNumber = Int(operation)
            } else {
                rightNumber = Int(operation)
            }
        } else {
            if nextOperation == nil && operation != ")" && operation != "(" {
                if useNewRules && operation == "*" {
                    nextOperation = operation
                    
                    let startIndex = operations.index(0, offsetBy: i + 1)
                    let partArrayToevaluate = Array(operations[startIndex ..< operations.endIndex])
                    
                    rightNumber = calculate(operations: partArrayToevaluate, useNewRules: useNewRules)
                    i += partArrayToevaluate.count
                } else {
                    nextOperation = operation
                }
            } else {
                switch operation {
                    case "(":
                        var additionalBrackets = 0
                        var upperBound = i + 1
                        while upperBound < operations.count {
                            if operations[upperBound] == "(" {
                                additionalBrackets += 1
                            }
                            if operations[upperBound] == ")" {
                                if additionalBrackets > 0 {
                                    additionalBrackets -= 1
                                } else {
                                    break
                                }
                            }
                            upperBound += 1
                        }
                        
                        let partArrayToevaluate = Array(operations[i + 1 ..< upperBound])
                        let result = calculate(operations: partArrayToevaluate, useNewRules: useNewRules)
                        if leftNumber == nil {
                            leftNumber = result
                        } else {
                            rightNumber = result
                        }
                        i += (partArrayToevaluate.count)
                        break
                    case ")":
                        break
                    default:
                        assertionFailure("unknown operation \(operation)")
                }
            }
        }
        
        if leftNumber != nil && rightNumber != nil && nextOperation != nil {
            switch nextOperation! {
                case "+":
                    leftNumber = leftNumber! + rightNumber!
                    rightNumber = nil
                    nextOperation = nil
                    break
                case "*":
                    leftNumber = leftNumber! * rightNumber!
                    rightNumber = nil
                    nextOperation = nil
                    break
                default:
                    assertionFailure("unknown operation \(operation)")
            }
        }
        
        i += 1
    }
    
    return leftNumber!
}

struct Day18 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day18", ofType: "txt")!).components(separatedBy: .newlines).filter { !$0.isEmpty }.map { $0.replacingOccurrences(of: "(", with: "( ").replacingOccurrences(of: ")", with: " )") }
        
        
        // MARK: - Task1
        let result = input.reduce(into: 0, { $0 += calculate(operations: $1.components(separatedBy: " ")) })
        print("Task1: The sum of all calculations ist: \(result)")
        
        // MARK: - Task2
        let result2 = input.reduce(into: 0, { $0 += calculate(operations: $1.components(separatedBy: " "), useNewRules: true) })
        print("Task2: The sum of all calculations ist: \(result2)")
        
    }
}
