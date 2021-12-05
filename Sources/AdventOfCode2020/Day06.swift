import Foundation


struct Day6 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day06", ofType: "txt")!)
        let groupAnswers = input.components(separatedBy: "\n\n")
        
        
        let yesAnswersTask1 = groupAnswers.reduce(into: 0) { $0 += $1.replacingOccurrences(of: "\n", with: "").reduce(into: Set<Character>()) { $0.insert($1) }.count }
        print("There were \(yesAnswersTask1) answers with yes in task 1.")
        
        
        let yesAnswersTask2 = groupAnswers.reduce(into: 0) { (result, groupAnswer) in
            var intersectionSet = Set<Character>("abcdefghijklmnopqrstuvwxyz")
            groupAnswer.components(separatedBy: .newlines).compactMap { $0.isEmpty ? nil : Set($0) }.forEach {
                intersectionSet = intersectionSet.intersection($0)
            }
            result += intersectionSet.count
        }
        print("There were \(yesAnswersTask2) answers with yes in task 2.")
    }
}
