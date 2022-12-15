import Foundation

struct Day14 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day14", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let lineInstructionPointss: [[(Int, Int)]] = inputRows.map {
            return $0.components(separatedBy: " -> ")
                .map {
                    let numbers = $0.components(separatedBy: ",")
                    return (Int(numbers[0])!, Int(numbers[1])!)
                }
        }
        
        /// Create sand map
        var highestX = 0
        var highestY = 0
        for line in lineInstructionPointss {
            for point in line {
                if point.0 > highestX {
                    highestX = point.0 + 1 /// + 1 because index starts at 0
                }
                if point.1 > highestY {
                    highestY = point.1 + 1 /// + 1 because index starts at 0
                }
            }
        }
        
        
        /// Init sand map
        func createSandMapWith(sizeX: Int, sizeY: Int) -> [[String]] {
            var sandMap = Array(repeating: Array(repeating: ".", count: sizeX), count: sizeY)
            
            sandMap[0][500] = "+"
            for line in lineInstructionPointss {
                for (index, startpoint) in line.enumerated() {
                    if index + 1 < line.count {
                        let endpoint = line[index + 1]
                        
                        if startpoint.0 == endpoint.0 {
                            /// vertical line
                            if startpoint.1 < endpoint.1 {
                                for y in startpoint.1...endpoint.1 {
                                    sandMap[y][startpoint.0] = "#"
                                }
                            } else {
                                for y in endpoint.1...startpoint.1 {
                                    sandMap[y][startpoint.0] = "#"
                                }
                            }
                        } else {
                            /// horizontal line
                            if startpoint.0 < endpoint.0 {
                                for x in startpoint.0...endpoint.0 {
                                    sandMap[startpoint.1][x] = "#"
                                }
                            } else {
                                for x in endpoint.0...startpoint.0 {
                                    sandMap[startpoint.1][x] = "#"
                                }
                            }
                        }
                    }
                }
            }
            
            return sandMap
        }
        
        
        var sandMap = createSandMapWith(sizeX: highestX, sizeY: highestY)
        var counterSand = 0
        
        func fillSandMapWithSand(canMapIncreaseHorizontally: Bool = false) {
            var sandPosition = (500, 0)
            
            while true {
                if sandPosition.0 + 1 >= highestX {
                    if canMapIncreaseHorizontally {
                        for y in 0 ..< sandMap.count {
                            sandMap[y].append(y == sandMap.count - 1 ? "#" : ".")
                        }
                        highestX += 1
                        
                    } else {
                        break
                    }
                }
                if sandPosition.1 + 1 >= highestY {
                    /// Sand drops out of range
                    break
                }
                
                
                
                if sandMap[sandPosition.1 + 1][sandPosition.0] == "." {
                    sandPosition.1 += 1
                    continue
                }
                
                if sandMap[sandPosition.1 + 1][sandPosition.0] == "#" || sandMap[sandPosition.1 + 1][sandPosition.0] == "o" {
                    if sandMap[sandPosition.1 + 1][sandPosition.0 - 1] == "#" || sandMap[sandPosition.1 + 1][sandPosition.0 - 1] == "o" {
                        if sandMap[sandPosition.1 + 1][sandPosition.0 + 1] == "#" || sandMap[sandPosition.1 + 1][sandPosition.0 + 1] == "o" {
                            sandMap[sandPosition.1][sandPosition.0] = "o"
                            counterSand += 1
                            if sandPosition == (500, 0) {
                                break
                            }
                            sandPosition = (500, 0)
                            continue
                        } else {
                            sandPosition.0 += 1
                            sandPosition.1 += 1
                            continue
                        }
                    } else {
                        sandPosition.0 -= 1
                        sandPosition.1 += 1
                        continue
                    }
                }
                
                break
            }
        }
        
        
        func printSandMap() {
            for line in sandMap {
                print(line.suffix(380).reduce("", +))
            }
        }
        
        
        // MARK: - Task 1
        
        fillSandMapWithSand()
        //printSandMap()
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("\(counterSand) units of sand come to rest, before it falls out")
        
        
        // MARK: - Task 2

        sandMap.append(Array(repeating: ".", count: sandMap[0].count))
        sandMap.append(Array(repeating: "#", count: sandMap[0].count))
        highestY += 2
        
        fillSandMapWithSand(canMapIncreaseHorizontally: true)
        //printSandMap()
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("\(counterSand) units of sand come to rest")
    }
}
