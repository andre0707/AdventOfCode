import Foundation

struct Day5 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        let inputRows = input.components(separatedBy: "\n\n").filter { !$0.isEmpty }
        
        let mappings: [[(source: Range<Int>, destination: Range<Int>)]] = (1...7).map {
            inputRows[$0]
                .components(separatedBy: .newlines)
                .compactMap {
                    guard $0.first?.isNumber ?? false else { return nil }
                    let components = $0.components(separatedBy: " ").compactMap { Int($0) }
                    let sourceRange = components[1]..<(components[1] + components[2])
                    let destinationRange = components[0]..<(components[0] + components[2])
                    
                    return (sourceRange, destinationRange)
                }
        }
        
        
        // MARK: - Task 1
        
        let seeds = inputRows[0].components(separatedBy: .whitespaces).compactMap { Int($0) }
        
        let locations = seeds.map { seed in
            var position = seed
            for mappingElement in mappings {
                for mapping in mappingElement {
                    if mapping.source.contains(position) {
                        position = mapping.destination.lowerBound + position - mapping.source.lowerBound
                        break
                    }
                }
            }
            return position
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The lowest location number is: \(locations.min()!)") // 214922730
        
        
        // MARK: - Task 2
        
        let seeds2 = stride(from: 0, to: seeds.count, by: 2).map {
            seeds[$0]...(seeds[$0] + seeds[$0 + 1])
        }
        var locations2: [Int] = []
//        for seedRange in seeds2 {
//            for seed in seedRange {
//                var position = seed
//                for mappingElement in mappings {
//                    for mapping in mappingElement {
//                        if mapping.source.contains(position) {
//                            position = mapping.destination.lowerBound + position - mapping.source.lowerBound
//                            break
//                        }
//                    }
//                }
//                locations2.append(position)
//            }
//        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The lowest location number is: \(locations2.min() ?? 0)") // 
    }
}

