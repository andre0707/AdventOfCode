import Foundation

struct Day19 {
    
    struct PartRating {
        var ratings: [Character : Int] = [:]
        
        init(input: String) {
            let parts = input
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: "")
                .components(separatedBy: ",")
            
            for part in parts {
                let components = part.components(separatedBy: "=")
                ratings[components[0].first!] = Int(components[1])!
            }
        }
        
        var value: Int { ratings.reduce(into: 0) { $0 += $1.value } }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day19", ofType: "txt")!)
        
        let inputComponents = input.dropLast(1).components(separatedBy: "\n\n")
        
        let parts = inputComponents[1].components(separatedBy: .newlines).map { PartRating(input: $0) }
        
        var workflows: [String : [String]] = [:]
        for workflow in inputComponents[0].components(separatedBy: .newlines) {
            let components = workflow.components(separatedBy: "{")
            workflows[components[0]] = components[1].dropLast().components(separatedBy: ",")
        }
        
        
        var acceptedParts: [PartRating] = []
        for part in parts {
            var currentWorkflow = "in"
        outerLoop:
            while true {
                let steps = workflows[currentWorkflow]!
                
                for var step in steps {
                    if !step.contains(":") && step != "R" && step != "A" {
                        currentWorkflow = step
                        continue outerLoop
                    }
                    let variable = step.removeFirst()
                    switch variable {
                    case "R":
                        break outerLoop
                    case "A":
                        acceptedParts.append(part)
                        break outerLoop
                    case "x", "m", "a", "s":
                        let operand = step.removeFirst()
                        let components = step.components(separatedBy: ":")
                        let value = Int(components[0])!
                        let nextWorkflow = components[1]
                        
                        if operand == ">" {
                            if part.ratings[variable]! > value {
                                if nextWorkflow == "R" { break outerLoop }
                                if nextWorkflow == "A" {
                                    acceptedParts.append(part)
                                    break outerLoop
                                }
                                currentWorkflow = nextWorkflow
                                continue outerLoop
                            }
                        } else if operand == "<" {
                            if part.ratings[variable]! < value {
                                if nextWorkflow == "R" { break outerLoop }
                                if nextWorkflow == "A" {
                                    acceptedParts.append(part)
                                    break outerLoop
                                }
                                currentWorkflow = nextWorkflow
                                continue outerLoop
                            }
                        } else {
                            assertionFailure()
                        }
                        
                    default:
                        assertionFailure()
                    }
                }
            }
        }
        
        // MARK: - Task 1
        
        let ratingSum = acceptedParts.map { $0.value }.reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("All ratings summed up: \(ratingSum)") // 332145
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
    }
}
