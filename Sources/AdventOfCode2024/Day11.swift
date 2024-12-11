import Foundation

struct Day11 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day11", ofType: "txt")!)
        let stoneValues = input.dropLast(1).components(separatedBy: .newlines)[0]
            .components(separatedBy: .whitespaces)
            .map { Int($0)! }
        
        /// mapping from stone number to amount of stones for this number
        let stones = stoneValues.reduce(into: [:], { $0[$1, default: 0] += 1 })
        
        func stoneCount(startingSones: [Int: Int], numberOfBlinks: Int) -> Int {
            var stones = startingSones
            
            for _ in 0..<numberOfBlinks {
                var stonesAfterBlinking: [Int: Int] = [:]
                
                for stone in stones {
                    if stone.key == 0 {
                        stonesAfterBlinking[1, default: 0] += stone.value
                        continue
                    }
                    
                    let keyAsString = "\(stone.key)"
                    if (keyAsString.count % 2) == 0 {
                        let middleIndex = keyAsString.index(keyAsString.startIndex, offsetBy: keyAsString.count / 2)
                        stonesAfterBlinking[Int(keyAsString[keyAsString.startIndex..<middleIndex])!, default: 0] += stone.value
                        stonesAfterBlinking[Int(keyAsString[middleIndex...])!, default: 0] += stone.value
                        continue
                    }
                    stonesAfterBlinking[stone.key * 2024, default: 0] += stone.value
                }
                stones = stonesAfterBlinking
            }
            
            return stones.reduce(into: 0, { $0 += $1.value })
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(stoneCount(startingSones: stones, numberOfBlinks: 25)) // 239714
        
        
        // MARK: - Task 2
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(stoneCount(startingSones: stones, numberOfBlinks: 75)) // 284973560658514
    }
}
