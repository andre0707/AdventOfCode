import Foundation

struct ContainingBag {
    let count: Int
    let color: String
}

struct BagRule {
    let color: String
    var containingBags: [ContainingBag] = []
    
    init?(from string: String) {
        if string.isEmpty { return nil }
        
        let components = string.components(separatedBy: " contain ")
        self.color = components[0].replacingOccurrences(of: " bags", with: "").replacingOccurrences(of: " ", with: "")
        
        if components[1] == "no other bags." { return }
        
        components[1].components(separatedBy: ", ").forEach {
            let bagRule = $0.replacingOccurrences(of: "bags", with: "").replacingOccurrences(of: "bag", with: "")
            let number = Int(bagRule.filter { $0.isNumber } ) ?? 0
            let color = bagRule.filter { $0.isLetter }
            self.containingBags.append(ContainingBag(count: number, color: color))
        }
    }
    
    func containingBagsContains(color: String) -> Bool {
        return self.containingBags.contains { $0.color == color }
    }
}


struct Day7 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day07", ofType: "txt")!)
        let rules = input.components(separatedBy: .newlines)
        
        let bagRules = rules.compactMap { BagRule(from: $0) }
        let startColor = "shinygold"
        
        
        func lookup(color: String, in bagRules: [BagRule], result: inout Set<String>) {
            bagRules.filter {
                $0.containingBagsContains(color: color)
            }.forEach {
                result.insert($0.color)
                lookup(color: $0.color, in: bagRules, result: &result)
            }
        }
        
        var result: Set<String> = []
        lookup(color: startColor, in: bagRules, result: &result)
        print("There are \(result.count) bag colors which could contain a \(startColor) bag")
        
        
        
        /*func lookup2(color: String, in bagRules: [BagRule]) -> Int {
            let bagRule = bagRules.first { $0.color == color }!
            
            var counted = 1
            bagRule.containingBags.forEach {
                counted += $0.count * lookup2(color: $0.color, in: bagRules)
            }
            
            return counted
        }
        print("There are \(lookup2(color: startColor, in: bagRules) - 1) individual bags required in mz single \(startColor) bag.")
        */
        
        
        // this is better
        
        func lookup3(color: String, in bagRules: [BagRule]) -> Int {
            return bagRules.first { $0.color == color }!.containingBags.reduce(1) {
                $0 + $1.count * lookup3(color: $1.color, in: bagRules)
            }
            
        }
        print("There are \(lookup3(color: startColor, in: bagRules) - 1) individual bags required in my single \(startColor) bag.")
    }
}
