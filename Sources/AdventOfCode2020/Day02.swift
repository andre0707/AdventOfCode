import Foundation

struct PasswordRule {
    let letterOccurrence: ClosedRange<Int>
    let letter: Character
    
    init(from string: String) {
        let ruleComponents = string.components(separatedBy: .whitespaces)
        self.letter = Character(ruleComponents[1])
        
        let occurenceComponents = ruleComponents[0].components(separatedBy: "-")
        self.letterOccurrence = Int(occurenceComponents[0])! ... Int(occurenceComponents[1])!
    }
}

struct Password {
    let rule: PasswordRule
    let password: String
    
    init(from line: String) {
        let baseComponents = line.components(separatedBy: ":")
        
        self.rule = PasswordRule(from: baseComponents[0])
        self.password = baseComponents[1].trimmingCharacters(in: .whitespaces)
    }
    
    var isValid: Bool {
        return self.rule.letterOccurrence.contains(self.password.filter { $0 == self.rule.letter }.count)
    }
    
    var isValid2: Bool {
        let firstPositionLetterIsRuleLetter = password[password.index(password.startIndex, offsetBy: rule.letterOccurrence.lowerBound - 1)] == rule.letter
        let secondPositionLetterIsRuleLetter = password[password.index(password.startIndex, offsetBy: rule.letterOccurrence.upperBound - 1)] == rule.letter
        
        return firstPositionLetterIsRuleLetter != secondPositionLetterIsRuleLetter
    }
}



struct Day2 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day02", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        print("There are \(inputLines.filter { Password(from: $0).isValid }.count) valid passwords with rule 1!")
        
        print("There are \(inputLines.filter { Password(from: $0).isValid2 }.count) valid passwords with rule 2!")
        
    }
}
