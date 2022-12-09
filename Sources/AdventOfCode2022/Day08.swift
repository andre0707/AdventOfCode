import Foundation

struct Day8 {
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day08", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let height = inputRows.count
        let width = inputRows[0].count
        var forestMap = Array(repeating: Array(repeating: 0, count: width), count: height)
        
        for (y, row) in inputRows.enumerated() {
            for (x, char) in row.enumerated() {
                forestMap[y][x] = Int(String(char))!
            }
        }
        
        var visibleTreesCount = 2 * height + 2 * width - 4
        var scenicViewForestMap = Array(repeating: Array(repeating: 0, count: width), count: height)
        
        for y in 1 ..< height - 1 {
            for x in 1 ..< width - 1 {
                let elementToCheck = forestMap[y][x]
                
                var treeVisibilityDirections = 4
                
                scenicViewForestMap[y][x] = 1
                var visibleDistance: Int? = 0
                
                /// Check visibility from left
                for dx in (0 ..< x).reversed() {
                    visibleDistance! += 1
                    if forestMap[y][dx] >= elementToCheck {
                        // Tree is not visible from left
                        treeVisibilityDirections -= 1
                        scenicViewForestMap[y][x] *= visibleDistance!
                        visibleDistance = nil
                        break
                    }
                }
                if let visibleDistance {
                    scenicViewForestMap[y][x] *= visibleDistance
                }
                
                                
                /// Check visibility from right
                visibleDistance = 0
                for element in forestMap[y][x + 1 ..< width] {
                    visibleDistance! += 1
                    if element >= elementToCheck {
                        // Tree is not visible from right
                        treeVisibilityDirections -= 1
                        scenicViewForestMap[y][x] *= visibleDistance!
                        visibleDistance = nil
                        break
                    }
                }
                if let visibleDistance {
                    scenicViewForestMap[y][x] *= visibleDistance
                }
                
                
                /// Check visibility from top
                visibleDistance = 0
                for dy in (0 ..< y).reversed() {
                    visibleDistance! += 1
                    if forestMap[dy][x] >= elementToCheck {
                        // Tree is not visible from top
                        treeVisibilityDirections -= 1
                        scenicViewForestMap[y][x] *= visibleDistance!
                        visibleDistance = nil
                        break
                    }
                }
                if let visibleDistance {
                    scenicViewForestMap[y][x] *= visibleDistance
                }
                
                
                /// Check visibility from bottom
                visibleDistance = 0
                for dy in (y + 1 ..< height) {
                    visibleDistance! += 1
                    if forestMap[dy][x] >= elementToCheck {
                        // Tree is not visible from top
                        treeVisibilityDirections -= 1
                        scenicViewForestMap[y][x] *= visibleDistance!
                        visibleDistance = nil
                        break
                    }
                }
                if let visibleDistance {
                    scenicViewForestMap[y][x] *= visibleDistance
                }
                
                
                if treeVisibilityDirections > 0 {
                    visibleTreesCount += 1
                }
            }
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("There are \(visibleTreesCount) trees visible")
        
        
        // MARK: - Task 2
        
        let scenicViewMaxScore = scenicViewForestMap
            .map { $0.max()! }
            .max()!
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Highest scenic view score: \(scenicViewMaxScore)")
    }
}
