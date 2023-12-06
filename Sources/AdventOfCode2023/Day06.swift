import Foundation

struct Day6 {
    
    struct Race {
        let time: Int
        let recordDistance: Int
        var beatingRecordDistanceCombiationCount = 0
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day06", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        // MARK: - Task 1
        
        let times = inputRows[0].components(separatedBy: .whitespaces).compactMap { Int($0) }
        let distances = inputRows[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
        
        var races = (0 ..< times.count).map {
            Race(time: times[$0], recordDistance: distances[$0])
        }
        
        for index in 0 ..< races.count {
            for startSpeed in 1 ..< races[index].time {
                let travelledDistance = startSpeed * (races[index].time - startSpeed)
                if travelledDistance > races[index].recordDistance {
                    races[index].beatingRecordDistanceCombiationCount += 1
                }
            }
        }
        
        var numberOfWinningWays = races.map(\.beatingRecordDistanceCombiationCount).reduce(1, *)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("There are \(numberOfWinningWays) ways to beat the record") // 316800
        
        
        // MARK: - Task 2
        
        numberOfWinningWays = 0
        let time = Int(inputRows[0].filter(\.isNumber))!
        let distance = Int(inputRows[1].filter(\.isNumber))!
        
        for startSpeed in 1 ..< time {
            let travelledDistance = startSpeed * (time - startSpeed)
            if travelledDistance > distance {
                numberOfWinningWays += 1
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("There are \(numberOfWinningWays) ways to beat the record") // 45647654
    }
}
