import Foundation

struct Day3 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day03", ofType: "txt")!)
        let lines = input.components(separatedBy: .newlines)
            .compactMap { line -> [Int]? in
                guard !line.isEmpty else { return nil }
                return line.map { $0.wholeNumberValue! }
            }
        guard !lines.isEmpty else { return }
        
        let lineLength = lines.first!.count
        
        
        // MARK: - Task 1
        
        var gammaRateBinary = ""
        var epsilonRateBinary = ""
        for i in 0 ..< lineLength {
            var countOnes = 0
            for line in lines {
                if line[i] == 1 {
                    countOnes += 1
                }
            }
            if countOnes > lines.count - countOnes {
                gammaRateBinary += "\(1)"
                epsilonRateBinary += "\(0)"
            } else {
                gammaRateBinary += "\(0)"
                epsilonRateBinary += "\(1)"
            }
        }
        
        let gammaRate = Int(gammaRateBinary, radix: 2)!
        let epsilonRate = Int(epsilonRateBinary, radix: 2)!
        print("gamma rate: \(gammaRateBinary) or decimal: \(gammaRate)")
        print("epsilon rate: \(epsilonRateBinary) or decimal: \(epsilonRate)")
        print("power consumption: \(gammaRate * epsilonRate)")
        
        
        // MARK: - Task 2
        
        func countOnes(at index: Int, in array: [[Int]]) -> Int {
            guard !array.isEmpty,
                  index >= 0,
                  index < array[0].count
            else { return 0 }
                        
            return array.filter { $0[index] == 1 }.count
        }
        
        func calculateRating(keepOnes: Bool) -> Int {
            var array = lines
            for i in 0 ..< lineLength {
                if array.count == 1 { break }
                let onesAtIndex = countOnes(at: i, in: array)
                let zerosAtIndex = array.count - onesAtIndex
                
                array = array.filter {
                    if keepOnes {
                        return $0[i] == (onesAtIndex >= zerosAtIndex ? 1 : 0)
                    } else {
                        return $0[i] == (onesAtIndex >= zerosAtIndex ? 0 : 1)
                    }
                }
            }
            
            return Int(array.first?.reduce(into: "", { (result, value) in result += "\(value)" }) ?? "0", radix: 2)!
        }
        
        let oxygenGeneratorLevel = calculateRating(keepOnes: true)
        let co2ScrubberRating = calculateRating(keepOnes: false)
        print("Oxygen generator level: \(oxygenGeneratorLevel)")
        print("CO2 scrubber rating: \(co2ScrubberRating)")
        print("life support rating: \(oxygenGeneratorLevel * co2ScrubberRating)")
    }
}
