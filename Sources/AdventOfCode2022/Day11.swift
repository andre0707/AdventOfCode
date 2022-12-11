import Foundation

struct Day11 {
    
    enum Operation {
        case add(Int)
        case multiply(Int)
        case square
        
        init?(from string: String) {
            let components = string.components(separatedBy: .whitespaces)
            guard components.count == 5 else { return nil }
            
            switch components[3] {
            case "+":
                self = .add(Int(components[4])!)
            case "*":
                if let value = Int(components[4]) {
                    self = .multiply(value)
                } else {
                    self = .square
                }
                
            default: return nil
            }
        }
    }
    
    struct Monkey {
        
        var items: [Int]
        let operation: Operation
        
        let testNumber: Int
        let monkeyIndexIfTestIsTrue: Int
        let monkeyIndexIfTestIsFalse: Int
        
        func updateWorryLevel(for item: Int) -> Int {
            switch operation {
            case .add(let value): return item + value
            case .multiply(let value): return item * value
            case .square: return item * item
            }
        }
        
        func monkeyIndexFor(itemToInspect item: Int) -> Int {
            item.isMultiple(of: testNumber) ? monkeyIndexIfTestIsTrue : monkeyIndexIfTestIsFalse
        }
        
        init(items: [Int], operation: Operation, testNumber: Int, monkeyIndexIfTestIsTrue: Int, monkeyIndexIfTestIsFalse: Int) {
            self.items = items
            self.operation = operation
            self.testNumber = testNumber
            self.monkeyIndexIfTestIsTrue = monkeyIndexIfTestIsTrue
            self.monkeyIndexIfTestIsFalse = monkeyIndexIfTestIsFalse
        }
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day11", ofType: "txt")!)
        let monkeyDescriptions = input.components(separatedBy: "\n\n").filter { !$0.isEmpty }
        
        
        let monkeysStart = monkeyDescriptions.map {
            let descriptionRows = $0.components(separatedBy: .newlines)
            
            var items: [Int]!
            var operation: Operation!
            var testNumber: Int!
            var monkeyIndexIfTestIsTrue: Int!
            var monkeyIndexIfTestIsFalse: Int!
            
            for (index, row) in descriptionRows.enumerated() {
                let rowComponents = row.components(separatedBy: ": ")
                
                switch index {
                case 1:
                    items = rowComponents[1].components(separatedBy: ", ").map { Int($0)! }
                case 2:
                    operation = Operation(from: rowComponents[1])
                case 3:
                    testNumber = Int(rowComponents[1].components(separatedBy: .whitespaces).last!)!
                case 4:
                    monkeyIndexIfTestIsTrue = Int(rowComponents[1].components(separatedBy: .whitespaces).last!)!
                case 5:
                    monkeyIndexIfTestIsFalse = Int(rowComponents[1].components(separatedBy: .whitespaces).last!)!
                default:
                    continue
                }
            }
            
            return Monkey(items: items, operation: operation, testNumber: testNumber, monkeyIndexIfTestIsTrue: monkeyIndexIfTestIsTrue, monkeyIndexIfTestIsFalse: monkeyIndexIfTestIsFalse)
        }
        
        
        // MARK: - Task 1
        
        var monkeys = monkeysStart
        var monkeyActivity = Array(repeating: 0, count: monkeys.count)
        
        for _ in 1...20 {
            for (monkeyIndex, monkey) in monkeys.enumerated() {
                while !monkeys[monkeyIndex].items.isEmpty {
                    let itemToInspect = monkey.updateWorryLevel(for: monkeys[monkeyIndex].items.removeFirst()) / 3
                    monkeys[monkey.monkeyIndexFor(itemToInspect: itemToInspect)].items.append(itemToInspect)
                    
                    monkeyActivity[monkeyIndex] += 1
                }
            }
        }
        
        var monkeyBusiness = monkeyActivity
            .sorted(by: >)
            .prefix(2)
            .reduce(1, *)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Level of monkey business: \(monkeyBusiness)")
        
        
        // MARK: - Task 2
        
        monkeys = monkeysStart
        monkeyActivity = Array(repeating: 0, count: monkeys.count)
        
        let leastCommonMultiple = monkeys.reduce(into: 1, { $0 *= $1.testNumber })
        
        for _ in 1...10_000 {
            for (monkeyIndex, monkey) in monkeys.enumerated() {
                while !monkeys[monkeyIndex].items.isEmpty {
                    let itemToInspect = monkey.updateWorryLevel(for: monkeys[monkeyIndex].items.removeFirst()) % leastCommonMultiple
                    monkeys[monkey.monkeyIndexFor(itemToInspect: itemToInspect)].items.append(itemToInspect)
                    
                    monkeyActivity[monkeyIndex] += 1
                }
            }
        }
        
        monkeyBusiness = monkeyActivity
            .sorted(by: >)
            .prefix(2)
            .reduce(1, *)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Level of monkey business: \(monkeyBusiness)")
    }
}
