import Foundation

struct Day2 {
    
    enum Hand {
        case rock
        case paper
        case scissors
        
        var scoreSelectedShape: Int {
            switch self {
            case .rock: return 1
            case .paper: return 2
            case .scissors: return 3
            }
        }
        
        init?(from char: String) {
            switch char {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissors
            default:
                return nil
            }
        }
        
        static func playerHand(for result: RoundResult, with elfHand: Hand) -> Hand {
            switch (result, elfHand) {
            case (.playerWins, .scissors),
                (.draw, .rock),
                (.elfWins, .paper):
                return .rock
            case (.playerWins, .rock),
                (.draw, .paper),
                (.elfWins, .scissors):
                return .paper
            case (.playerWins, .paper),
                (.draw, .scissors),
                (.elfWins, .rock):
                return .scissors
            }
        }
    }
    
    enum RoundResult {
        case playerWins
        case draw
        case elfWins
        
        init(elfHand: Hand, playerHand: Hand) {
            switch (elfHand, playerHand) {
            case (.rock, .rock),
                (.paper, .paper),
                (.scissors, .scissors):
                self = .draw
            case (.rock, .scissors),
                (.paper, .rock),
                (.scissors, .paper):
                self = .elfWins
            case (.rock, .paper),
                (.paper, .scissors),
                (.scissors, .rock):
                self = .playerWins
            }
        }
        
        init?(from char: String) {
            switch char {
            case "X":
                self = .elfWins
            case "Y":
                self = .draw
            case "Z":
                self = .playerWins
            default:
                return nil
            }
        }
        
        static func playerPoints(for result: RoundResult) -> Int {
            switch result {
            case .elfWins: return 0
            case .draw: return 3
            case .playerWins: return 6
            }
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day02", ofType: "txt")!)
        let rounds = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        var playerPoints = 0
        
        
        // MARK: - Task 1
        
        for round in rounds {
            let hands = round.components(separatedBy: " ")
            
            let playerHand = Hand(from: hands[1])!
            let roundResult = RoundResult(elfHand: Hand(from: hands[0])!, playerHand: playerHand)
            playerPoints += playerHand.scoreSelectedShape
            playerPoints += RoundResult.playerPoints(for: roundResult)
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Player has \(playerPoints) points")
        
        
        // MARK: - Task 2
        
        playerPoints = 0
        for round in rounds {
            let elements = round.components(separatedBy: " ")
            
            let elfHand = Hand(from: elements[0])!
            let neededResult = RoundResult(from: elements[1])!
            let playerHand = Hand.playerHand(for: neededResult, with: elfHand)
            
            playerPoints += playerHand.scoreSelectedShape
            playerPoints += RoundResult.playerPoints(for: neededResult)
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Player has \(playerPoints) points")
    }
}
