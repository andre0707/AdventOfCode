import Foundation

struct Day7 {
    
    static func cardRank(for card: Character, useJoker: Bool) -> Int {
        switch card {
        case "A": return 13
        case "K": return 12
        case "Q": return 11
        case "J": return useJoker ? 0 : 10
        case "T": return 9
        case "9": return 8
        case "8": return 7
        case "7": return 6
        case "6": return 5
        case "5": return 4
        case "4": return 3
        case "3": return 2
        case "2": return 1
        default:
            assertionFailure()
            return 0
        }
    }
    
    enum HandType: Int, Equatable, Comparable {
        case fiveOfAKind = 7
        case fourOfAKind = 6
        case fullHouse = 5
        case threeOfAKind = 4
        case twoPair = 3
        case onePair = 2
        case highCard = 1
        
        static func < (lhs: Day7.HandType, rhs: Day7.HandType) -> Bool { lhs.rawValue < rhs.rawValue }
    }
    
    struct GameRound {
        let hand: [Character]
        let bid: Int
        let handType: HandType
        
        init(hand: String, bid: Int, useJokers: Bool) {
            self.bid = bid
            self.hand = hand.map { $0 }
            
            var cards: [Character : Int] = [:]
            for card in hand {
                cards[card, default: 0] += 1
            }
            
            let jokerCount: Int
            if useJokers {
                jokerCount = cards.removeValue(forKey: "J") ?? 0
            } else {
                jokerCount = 0
            }
            
            switch cards.count {
            case 0, 1:
                self.handType = .fiveOfAKind
            case 2:
                if cards.values.max()! + jokerCount == 4 {
                    self.handType = .fourOfAKind
                } else {
                    self.handType = .fullHouse
                }
            case 3:
                if cards.values.max()! + jokerCount == 3 {
                    self.handType = .threeOfAKind
                } else {
                    self.handType = .twoPair
                }
            case 4:
                self.handType = .onePair
            case 5:
                self.handType = .highCard
                
            default:
                self.handType = .highCard
                assertionFailure()
            }
        }
        
        func isWeaker(than otherHand: Day7.GameRound, useJoker: Bool) -> Bool {
            if handType < otherHand.handType { return true }
            if handType > otherHand.handType { return false }
            for index in 0 ..< hand.count {
                let lhsCardRank = cardRank(for: hand[index], useJoker: useJoker)
                let rhsCardRank = cardRank(for: otherHand.hand[index], useJoker: useJoker)
                if lhsCardRank < rhsCardRank { return true }
                if lhsCardRank > rhsCardRank { return false }
            }
            return true
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day07", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        // MARK: - Task 1
        
        var gameRounds = inputRows
            .map {
                let components = $0.components(separatedBy: .whitespaces)
                return GameRound(hand: components[0], bid: Int(components[1])!, useJokers: false)
            }
            .sorted(by: { $0.isWeaker(than: $1, useJoker: false) })
        
        var totalWinnings = gameRounds
            .enumerated()
            .reduce(into: 0, {
                $0 += ($1.offset + 1) * $1.element.bid
            })
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("Total winnings are: \(totalWinnings)") // 248105065
        
        
        // MARK: - Task 2
        
        gameRounds = inputRows
            .map {
                let components = $0.components(separatedBy: .whitespaces)
                return GameRound(hand: components[0], bid: Int(components[1])!, useJokers: true)
            }
            .sorted(by: { $0.isWeaker(than: $1, useJoker: true) })
        
        totalWinnings = gameRounds
            .enumerated()
            .reduce(into: 0, {
                $0 += ($1.offset + 1) * $1.element.bid
            })
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Total winnings are: \(totalWinnings)") // 249515436
    }
}
