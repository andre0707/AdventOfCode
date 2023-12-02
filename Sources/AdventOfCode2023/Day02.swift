import Foundation

struct Day2 {
    
    struct GameSet {
        var red: Int
        var green: Int
        var blue: Int
        
        var isValid: Bool {
            if red > 12 { return false }
            if green > 13 { return false }
            if blue > 14 { return false }
            return true
        }
    }
    
    struct Game {
        let id: Int
        let sets: [GameSet]
        
        var isValid: Bool { sets.allSatisfy(\.isValid) }
        
        var power: Int {
            let maxRed = sets.max { $0.red < $1.red }!.red
            let maxGreen = sets.max { $0.green < $1.green }!.green
            let maxBlue = sets.max { $0.blue < $1.blue }!.blue
            
            return maxRed * maxGreen * maxBlue
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day02", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let games = inputRows.map {
            let row = $0.replacingOccurrences(of: " ", with: "")
            let gameComponents = row.components(separatedBy: ":")
            let gameId = Int(gameComponents[0].filter { $0.isNumber })!
            let gameSets = gameComponents[1].components(separatedBy: ";").map {
                var red = 0
                var green = 0
                var blue = 0
                let cubes = $0.components(separatedBy: ",")
                for cube in cubes {
                    let amount = Int(cube.filter { $0.isNumber })!
                    let color = cube.filter { $0.isLetter }
                    switch color {
                    case "red":
                        red = amount
                    case "green":
                        green = amount
                    case "blue":
                        blue = amount
                    default:
                        assertionFailure()
                    }
                }
                return GameSet(red: red, green: green, blue: blue)
            }
            
            return Game(id: gameId, sets: gameSets)
        }
        
        
        
        // MARK: - Task 1
        
        let matchingGames = games.filter(\.isValid)
        
        let gameIdsSum = matchingGames.reduce(into: 0, { $0 += $1.id })
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("There are \(gameIdsSum) valid games")
        
        
        // MARK: - Task 2
        
        let sumOfPower = games.reduce(into: 0, { $0 += $1.power })
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The sum of the power is: \(sumOfPower)")
    }
}
