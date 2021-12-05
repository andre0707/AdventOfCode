import Foundation


struct Day13 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day13", ofType: "txt")!).components(separatedBy: .newlines)
        
        let arrivalTime = Int(input[0])!
        let buses: [(index: Int, busId: Int)] = input[1].components(separatedBy: ",").enumerated().compactMap {
            guard let busId = Int($0.1) else { return nil }
            return (index: $0.0, busId: busId)
        }
        
        // MARK: - Task1
        
        let timeDeltas = buses.map { (busId: $0.busId, timeDelta: $0.busId - arrivalTime % $0.busId) }
        let minDelta = timeDeltas.min { $0.timeDelta < $1.timeDelta }!
        print("Task1: Bus with id \(minDelta.busId) will be there in \(minDelta.timeDelta) minutes. Waitscore = \(minDelta.busId * minDelta.timeDelta)")
        
        
        
        
        // MARK: - Task2
        
        
        // way too slow
        /*
        var t = 0
        var step = 1
        loop: while true {
            t += step
            for bus in buses {
                if ((t + bus.index) % bus.busId) != 0 { continue loop }
                step = bus.busId
            }
            break
        }
        */
        
        
        var timestamp = 0
        var step = 1

        for bus in buses {
            while true {
                timestamp += step
                if ((timestamp + bus.index) % bus.busId) != 0 { continue }
                step *= bus.busId //increase the step with the factor of the new matching busId to have way less iterations. Steps in between would not match the current bus otherwise
                break
            }
        }
        
        print("Task2: The earliest timestamp is: \(timestamp)")
        
    }
}
