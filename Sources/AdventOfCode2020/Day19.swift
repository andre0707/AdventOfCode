import Foundation


struct Rule {
    let list1: [Int]?
    let list2: [Int]?
    
    let char: Character?
}


struct Day19 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!).components(separatedBy: "\n\n")
        
        let messages = input[1].components(separatedBy: .newlines)
        let linesWithRules = input[0].components(separatedBy: .newlines)
        var rules: [Int : Rule] = [:]
        for line in linesWithRules {
            let components = line.components(separatedBy: ": ")
            let rule = components[1]
            
            if rule.contains("\"") {
                let char = rule[rule.index(after: rule.startIndex)]
                rules[Int(components[0])!] = Rule(list1: nil, list2: nil, char: char)
                continue
            }
            if rule.contains("|") {
                let comps = rule.components(separatedBy: "|")
                rules[Int(components[0])!] = Rule(list1: comps[0].components(separatedBy: .whitespaces).compactMap { Int($0) }, list2: comps[1].components(separatedBy: .whitespaces).compactMap { Int($0) }, char: nil)
                continue
            }
            
            rules[Int(components[0])!] = Rule(list1: rule.components(separatedBy: .whitespaces).compactMap { Int($0) }, list2: nil, char: nil)
        }
 
        
        func ruleMatches(_ exs: [String], ruleNumber: Int, rulesDict: [Int: Rule]) -> [String]? {
            let rule = rulesDict[ruleNumber]
            if let char = rule?.char {
                return exs.compactMap { ex in
                        if ex.first == char {
                            return String(ex[ex.index(ex.startIndex, offsetBy: 1)..<ex.endIndex])
                    } else {
                        return nil
                    }
                }
            }
            var condition1Matches = [String]()
            if let condition1 = rule?.list1 {
                for ex in exs {
                    if ex != "" {
                        var leftovers: [String]? = [ex]
                        for ruleNumber in condition1 {
                            if let leftoversNN = leftovers {
                                leftovers = ruleMatches(leftoversNN, ruleNumber: ruleNumber, rulesDict: rulesDict)
                            }
                        }
                        
                        if let leftoversNN = leftovers {
                            condition1Matches.append(contentsOf: leftoversNN)
                        }
                    }
                }
            }
            var condition2Matches = [String]()
            if let condition2 = rule?.list2 {
                for ex in exs {
                    if ex != "" {
                        var leftovers: [String]? = [ex]
                        for ruleNumber in condition2 {
                            if let leftoversNN = leftovers {
                                leftovers = ruleMatches(leftoversNN, ruleNumber: ruleNumber, rulesDict: rulesDict)
                            }
                        }
                        
                        if let leftoversNN = leftovers {
                            condition2Matches.append(contentsOf: leftoversNN)
                        }
                    }
                }
            }
            return condition1Matches + condition2Matches
        }

        //ruleMatches([messages[0]], ruleNumber: 0, rulesDict: rules)
        
        
        func check(_ expressionsToTest: [String], ruleNumber: Int) -> [String] {
            guard let rule = rules[ruleNumber] else { fatalError("invalid rule number \(ruleNumber)") }
            
            if let char = rule.char {
                return expressionsToTest.compactMap { expressionToTest in
                    if expressionToTest.first == char {
                        return String(expressionToTest[expressionToTest.index(expressionToTest.startIndex, offsetBy: 1) ..< expressionToTest.endIndex])
                    }
                    return nil
                }
            }
            
            var validExpressions: [String] = []
            if let list1 = rule.list1 {
                for expressionToTest in expressionsToTest {
                    var expressionsToTestNext = [expressionToTest]
                    for rn in list1 {
                        expressionsToTestNext = check(expressionsToTestNext, ruleNumber: rn)
                        if expressionsToTestNext.isEmpty { return [] }
                    }
                    validExpressions.append(contentsOf: expressionsToTestNext)
                }
            }
            
            if let list2 = rule.list2 {
                for expressionToTest in expressionsToTest {
                    var expressionsToTestNext = [expressionToTest]
                    for rn in list2 {
                        expressionsToTestNext = check(expressionsToTestNext, ruleNumber: rn)
                        if expressionsToTestNext.isEmpty { return [] }
                    }
                    validExpressions.append(contentsOf: expressionsToTestNext)
                }
            }
            
            return validExpressions
        }
        
        print("Message is\(check([messages[0]], ruleNumber: 0).isEmpty ? " not" : "") valid")
        
        
        /*
        var validMessages: Set<String> = []
        
        
        guard let rule = rules[0] else { fatalError("starting rule is missing") }
        
        func analyseRule(rule: String) -> [String] {
            if ["a", "b"].contains(rule) { return [rule] }
            
            let ruleComponents = rule.components(separatedBy: .whitespaces)
            
            
            for ruleComponent in ruleComponents {
                switch ruleComponent {
                    case "|":
                        break
                    default:
                        guard let ruleNumberToLookup = Int(ruleComponent) else { fatalError("invalid number") }
                        guard let nextRule = rules[ruleNumberToLookup] else { fatalError("rule is missing") }
                        
                        let result = analyseRule(rule: nextRule)
                }
            }
            
            
            
            return analyseRule(rule: rule).contains(message)
        }
        
        let messages = input[1].components(separatedBy: .newlines)
 
        */
        
        /*
        guard var rule = rules[0] else { fatalError("starting rule is missing") }
        
        var startIndexNextRuleNumber: String.Index? = nil
        var endIndexNextRuleNumber: String.Index = rule.startIndex
        var index = rule.startIndex
        while index < rule.endIndex {
            switch rule[index] {
                case " ":
                    guard let startIndex = startIndexNextRuleNumber else { continue }
                    guard let nextRuleNumber = Int(rule[startIndex ... endIndexNextRuleNumber]) else { fatalError("invalid rule number") }
                    guard let nextRule = rules[nextRuleNumber] else { fatalError("unknown rule") }
                    rule.replaceSubrange(startIndex ... endIndexNextRuleNumber, with: "(\(nextRule))")
                    index = startIndex
                    startIndexNextRuleNumber = nil
                    break
                case "|":
                    //todo
                    break
                default:
                    if startIndexNextRuleNumber == nil {
                        startIndexNextRuleNumber = index
                    }
                    endIndexNextRuleNumber = index
                    break
            }
            index = rule.index(after: index)
        }
        */
        
        // MARK: - Task1
        //print("Task1: There are \(messages.reduce(into: 0, { $0 += (validMessages.contains($1) ? 1 : 0) })) valid messages")
        
        
        // MARK: - Task2
        //print("Task2: ")
        
    }
}


/*
0: a 1 b
1: 2 3 | 3 2
2: aa | bb
3: ab | ba
4: "a"
5: "b"


0: a aa | bb ab | ba | ab | ba aa | bb b
1: aa | bb ab | ba | ab | ba aa | bb
2: aa | bb
3: ab | ba
4: "a"
5: "b"


0: a 1 b
1: ((aa | bb)(ab | ba)) | ((ab | ba)(aa | bb))
2: aa | bb
3: ab | ba
4: "a"
5: "b"


0: a((aa|bb)(ab|ba))|((ab|ba)(aa|bb))b
1: (aa | bb)(ab | ba) | (ab | ba)(aa | bb)
2: aa | bb
3: ab | ba
4: "a"
5: "b"
*/
