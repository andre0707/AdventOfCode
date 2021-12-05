import Foundation

struct Day5 {
    typealias Map = [[Int]]
    typealias Coordinate = (x: Int, y: Int)
    
    struct Line {
        var from: Coordinate
        var to: Coordinate
    }
    
    struct HydrothermalVentMap: CustomStringConvertible {
        private var map: Map = [[0]]
        
        init(with mapLines: [Line], allowDiagonalLines: Bool) {
            for mapLine in mapLines {
                /// Extend map to fit lines
                let maxX = max(mapLine.from.x, mapLine.to.x)
                let maxY = max(mapLine.from.y, mapLine.to.y)
                
                let currentCountX = map[0].count
                if currentCountX <= maxX {
                    for lineIndex in map.indices {
                        (0 ... maxX - currentCountX).forEach { _ in
                            map[lineIndex].append(0)
                        }
                    }
                }
                let currentCountY = map.count
                if currentCountY <= maxY {
                    (0 ... maxY - currentCountY).forEach { _ in
                        map.append(Array(repeating: 0, count: map[0].count))
                    }
                }
                
                /// Add lines
                if mapLine.from.x == mapLine.to.x {
                    /// Horizontal lines
                    let range = mapLine.from.y < mapLine.to.y ? (mapLine.from.y ... mapLine.to.y) : (mapLine.to.y ... mapLine.from.y)
                    range.forEach { y in
                        map[y][mapLine.from.x] += 1
                    }
                } else if mapLine.from.y == mapLine.to.y {
                    /// Vertical lines
                    let range = mapLine.from.x < mapLine.to.x ? (mapLine.from.x ... mapLine.to.x) : (mapLine.to.x ... mapLine.from.x)
                    range.forEach { x in
                        map[mapLine.from.y][x] += 1
                    }
                } else if allowDiagonalLines {
                    /// Diagonal lines
                    let goDown = mapLine.from.y < mapLine.to.y
                    
                    if mapLine.from.x < mapLine.to.x {
                        /// From left top to right bottom OR left bottom to right top
                        (mapLine.from.x ... mapLine.to.x).enumerated().forEach { (index, x) in
                            let y = goDown ? mapLine.from.y + index : mapLine.from.y - index
                            map[y][x] += 1
                        }
                    } else {
                        /// From right top to left bottom OR right bottom to left top
                        (mapLine.to.x ... mapLine.from.x).enumerated().forEach { (index, x) in
                            let y = goDown ? mapLine.to.y - index : mapLine.to.y + index
                            map[y][x] += 1
                        }
                    }
                }
            }
        }
        
        var overlappingPointsCount: Int {
            return map.reduce(into: 0, { (result, nextVale) in
                result += nextVale.reduce(into: 0, { (result, nextValue) in
                    result += nextValue > 1 ? 1 : 0
                })
            })
        }
        
        var description: String {
            var result = ""
            for row in map {
                for column in row {
                    result += column == 0 ? "." : "\(column)"
                }
                result += "\n"
            }
            
            return result
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day05", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines).dropLast()
        
        let mapLines = inputLines.map { stringLine -> Line in
            let coordinates = stringLine.components(separatedBy: " -> ")
            let fromParts = coordinates[0].components(separatedBy: ",")
            let from = Coordinate(x: Int(fromParts[0])!, y: Int(fromParts[1])!)
            
            let toParts = coordinates[1].components(separatedBy: ",")
            let to = Coordinate(x: Int(toParts[0])!, y: Int(toParts[1])!)
            return Line(from: from, to: to)
        }
        
        
        // MARK: - Task 1
        
        print("There are \(HydrothermalVentMap(with: mapLines, allowDiagonalLines: false).overlappingPointsCount) overlapping points")
        
        
        // MARK: - Task 2
        
        print("There are \(HydrothermalVentMap(with: mapLines, allowDiagonalLines: true).overlappingPointsCount) overlapping points")
    }
}
