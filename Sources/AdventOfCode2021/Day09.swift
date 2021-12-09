import Foundation

struct Day9 {
    typealias Coordinates = (row: Int, column: Int)
    
    final class HeatMap {
        private let data: [[Int]]
        
        private var lowPoints: [Coordinates] = []
        
        init(data: [[Int]]) {
            self.data = data
            
            self.lowPoints = coordinatesForLowPoints()
        }
        
        private func point(for coordinate: Coordinates) -> Int? {
            guard coordinate.row >= 0, coordinate.row < data.count else { return nil }
            guard coordinate.column >= 0, coordinate.column < data[coordinate.row].count else { return nil }
            
            return data[coordinate.row][coordinate.column]
        }
        
        private func coordinatesForLowPoints() -> [Coordinates] {
            var coordinates = [Coordinates]()
            for row in 0 ..< data.count {
                for column in 0 ..< data[row].count {
                    let value = point(for: (row, column))!
                    
                    if let up = point(for: (row - 1, column)), up <= value { continue }
                    if let down = point(for: (row + 1, column)), down <= value { continue }
                    if let left = point(for: (row, column - 1)), left <= value { continue }
                    if let right = point(for: (row, column + 1)), right <= value { continue }
                    
                    coordinates.append((row, column))
                }
            }
            return coordinates
        }
        
        enum BasinDirection {
            case up, down, left, right
        }
        
        private var visitedBasinPoints = [Coordinates]()
        private func basinSize(for point: Coordinates, sourcePointIsBased: BasinDirection?) -> Int {
            guard let value = self.point(for: point), value < 9 else { return 0 }
            guard !visitedBasinPoints.contains(where: { $0.column == point.column && $0.row == point.row }) else { return 0 }
            
            var size = 1
            visitedBasinPoints.append(point)
            
            if let sourceDirection = sourcePointIsBased {
                switch sourceDirection {
                case .up:
                    size += basinSize(for: (point.row + 1, point.column), sourcePointIsBased: .up)
                    size += basinSize(for: (point.row, point.column - 1), sourcePointIsBased: .right)
                    size += basinSize(for: (point.row, point.column + 1), sourcePointIsBased: .left)
                    return size
                case .down:
                    size += basinSize(for: (point.row - 1, point.column), sourcePointIsBased: .down)
                    size += basinSize(for: (point.row, point.column - 1), sourcePointIsBased: .right)
                    size += basinSize(for: (point.row, point.column + 1), sourcePointIsBased: .left)
                    return size
                case .left:
                    size += basinSize(for: (point.row - 1, point.column), sourcePointIsBased: .down)
                    size += basinSize(for: (point.row + 1, point.column), sourcePointIsBased: .up)
                    size += basinSize(for: (point.row, point.column + 1), sourcePointIsBased: .left)
                    return size
                case .right:
                    size += basinSize(for: (point.row - 1, point.column), sourcePointIsBased: .down)
                    size += basinSize(for: (point.row + 1, point.column), sourcePointIsBased: .up)
                    size += basinSize(for: (point.row, point.column - 1), sourcePointIsBased: .right)
                    return size
                }
            }
            
            size += basinSize(for: (point.row - 1, point.column), sourcePointIsBased: .down)
            size += basinSize(for: (point.row + 1, point.column), sourcePointIsBased: .up)
            size += basinSize(for: (point.row, point.column - 1), sourcePointIsBased: .right)
            size += basinSize(for: (point.row, point.column + 1), sourcePointIsBased: .left)
            visitedBasinPoints.removeAll()
            return size
        }
        
        var riskLevel: Int {
            lowPoints.reduce(0, { (result, nextValue) -> Int in
                result + point(for: nextValue)! + 1
            })
        }
        
        var largestBasinScore: Int {
            lowPoints
                .map { basinSize(for: $0, sourcePointIsBased: nil) }
                .sorted()
                .suffix(3)
                .reduce(1, *)
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day09", ofType: "txt")!)
        
        let data = input
            .components(separatedBy: .newlines)
            .map { line in
                line.compactMap { $0.wholeNumberValue }
            }
        
        let heatMap = HeatMap(data: data)
        
        
        // MARK: - Task 1
        
        print("The risk level is: \(heatMap.riskLevel)")
        
        
        // MARK: - Task 2
        
        print("The three highest basins multyplied are: \(heatMap.largestBasinScore)")
    }
}
