import Foundation


struct Day3 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day03", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        let slopes = [
            (right: 1, down: 1),
            (right: 3, down: 1),
            (right: 5, down: 1),
            (right: 7, down: 1),
            (right: 1, down: 2)
        ]
        
        var totalHitTrees = 1
        slopes.forEach { slope in
            var hitTreesInCurrentSlope = 0
            for (currentRow, rowText) in inputLines.enumerated() {
                if currentRow % slope.down > 0 { continue }
                
                let distance = rowText.distance(from: rowText.startIndex, to: rowText.endIndex)
                let offset = (currentRow * slope.right / slope.down) % distance
                let index = rowText.index(rowText.startIndex, offsetBy: offset)
                if rowText[index] == "#" { hitTreesInCurrentSlope += 1 }
            }
            
            totalHitTrees *= hitTreesInCurrentSlope
            print("\(hitTreesInCurrentSlope) trees were hit in this slope")
        }
        print("\(totalHitTrees) trees were hit total")
    }
}
