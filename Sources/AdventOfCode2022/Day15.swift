import Foundation


extension ClosedRange where Element == Int {
    func extend(with otherRange: ClosedRange) -> ClosedRange? {
        
        if lowerBound <= otherRange.lowerBound && upperBound >= otherRange.upperBound { return self }
        if otherRange.lowerBound <= lowerBound && otherRange.upperBound >= upperBound { return otherRange }
        
        if otherRange.upperBound >= upperBound && otherRange.lowerBound - 1 <= upperBound ||
            otherRange.lowerBound <= lowerBound && otherRange.upperBound + 1 >= lowerBound {
            return Swift.min(lowerBound, otherRange.lowerBound)...Swift.max(upperBound, otherRange.upperBound)
        }
        
        return nil
    }
}

struct Day15 {
    
    struct Sensor {
        let x: Int
        let y: Int
        
        let closestBeaconPosition: (x: Int, y: Int)
        
        var manhattanDistance: Int { abs(x - closestBeaconPosition.x) + abs(y - closestBeaconPosition.y) }
    }
    
    static func run() {
        let useTestData = false
        
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day\(useTestData ? "Test" : "15")", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let sensors = inputRows
            .map {
                let components = $0
                    .replacingOccurrences(of: "Sensor at ", with: "")
                    .replacingOccurrences(of: " closest beacon is at ", with: "")
                    .components(separatedBy: ":")
                
                let sensorData = components[0]
                    .replacingOccurrences(of: "x=", with: "")
                    .replacingOccurrences(of: "y=", with: "")
                    .components(separatedBy: ", ")
                
                let sensorCoordiantes = (Int(sensorData[0])!, Int(sensorData[1])!)
                
                let beaconData = components[1]
                    .replacingOccurrences(of: "x=", with: "")
                    .replacingOccurrences(of: "y=", with: "")
                    .components(separatedBy: ", ")
                
                let beaconCoordiantes = (Int(beaconData[0])!, Int(beaconData[1])!)
                
                return Sensor(x: sensorCoordiantes.0, y: sensorCoordiantes.1, closestBeaconPosition: beaconCoordiantes)
            }
        
        
        func checkRanges(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
            guard !ranges.isEmpty else { return [] }
            
            var result: [ClosedRange<Int>] = ranges
            
            for _ in 0 ..< ranges.count {
                let first = result.removeFirst()
                
                var didExtend = false
                for i in 0 ..< result.count {
                    if let combined = first.extend(with: result[i]) {
                        result[i] = combined
                        didExtend = true
                    }
                }
                if !didExtend {
                    result.append(first)
                }
            }
            
            return result
        }
        
        
        var sensorBeaconMap: [Int : [ClosedRange<Int>]] = [:]

        for sensor in sensors {
            let manhattanLength = sensor.manhattanDistance
            
            for y in sensor.y - manhattanLength ... sensor.y + manhattanLength {
                let dx = manhattanLength - abs(sensor.y - y)
                let range = sensor.x - dx ... sensor.x + dx
                
                if var existingRanges = sensorBeaconMap[y] {
                    existingRanges.append(range)
                    sensorBeaconMap[y] = checkRanges(existingRanges)
                } else {
                    sensorBeaconMap[y] = [range]
                }
            }
        }
        
        
        // MARK: - Task 1
        
        let lineToCheck = useTestData ? 10 : 2000000
        let countPositions = sensorBeaconMap[lineToCheck]?.reduce(into: 0, { $0 += ($1.upperBound - $1.lowerBound)  }) ?? 0
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("In line \(lineToCheck) there are \(countPositions) positions in which the beacon can not be located.")
        
        
        // MARK: - Task 2
        
        let minValue = 0
        let maxValue = useTestData ? 20 : 4000000
        
        let potentialMatches = sensorBeaconMap.filter {
            guard $0 >= minValue else { return false }
            guard $0 <= maxValue else { return false }
            return $1.count > 1
        }
        
        var x = 0
        var y = 0
        if let match = potentialMatches.first, match.value.count == 2 {
            y = match.key
            if match.value[0].lowerBound < match.value[1].lowerBound {
                x = match.value[0].upperBound + 1
            } else {
                x = match.value[1].upperBound + 1
            }
        }
        
        
        let tuningFrequency = x * 4000000 + y
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The tuning frequency is: \(tuningFrequency)")
    }
}
