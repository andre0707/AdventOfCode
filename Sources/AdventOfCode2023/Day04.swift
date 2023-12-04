import Foundation

struct Day4 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day04", ofType: "txt")!)
        let inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        var points = 0
        var numberOfCarsById: [Int : Int] = [:]
        
        for row in inputRows {
            let splittedRow = row.components(separatedBy: " | ")
            let leftComponents = splittedRow[0].components(separatedBy: ": ")
            let cardNumber = Int(leftComponents[0].filter(\.isNumber))!
            
            numberOfCarsById[cardNumber, default: 0] += 1
            
            let winningNumbers = Set(leftComponents[1].components(separatedBy: " ").compactMap { Int($0) })
            let numbersTheElfHas = Set(splittedRow[1].components(separatedBy: " ").compactMap { Int($0) })
            
            let numbersWhichBringPoints = numbersTheElfHas.intersection(winningNumbers)
            let pointsForTheCard: Int = numbersWhichBringPoints.isEmpty ? 0 : Int(pow(Double(2), Double(numbersWhichBringPoints.count - 1)))
            points += pointsForTheCard
            
            for i in 0 ..< numbersWhichBringPoints.count {
                numberOfCarsById[cardNumber + i + 1, default: 0] += numberOfCarsById[cardNumber]!
            }
        }
        
        
        // MARK: - Task 1
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The Elf has \(points) points") // 24542
        
        
        // MARK: - Task 2
        
        let numberOfScratchCards = numberOfCarsById.map(\.value).reduce(0, +)
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The Elf has ends up with \(numberOfScratchCards) scratch cards") // 8736438
    }
}
