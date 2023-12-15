import Foundation

extension String {
    var lensLibraryHashValue: Int {
        var value = 0
        for char in self {
            guard let ascii = char.asciiValue else { continue }
            value += Int(ascii)
            value = (value * 17) % 256
        }
        return value
    }
}

struct Day15 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day15", ofType: "txt")!)
        
        let steps = input
            .dropLast(1)
            .components(separatedBy: ",")
        
        
        // MARK: - Task 1
        
        let hashes: [Int] = steps.map { $0.lensLibraryHashValue }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum of the results is \(hashes.reduce(0, +))") // 515974
        
        
        // MARK: - Task 2
        
        var boxMap: [Int : [(String, Int)]] = [:]
        
        for step in steps {
            if step.last == "-" {
                let label = step.dropLast(1)
                let boxNumber = String(label).lensLibraryHashValue
                if var boxContent = boxMap[boxNumber] {
                    boxContent.removeAll(where: { $0.0 == label })
                    if boxContent.isEmpty {
                        boxMap.removeValue(forKey: boxNumber)
                    } else {
                        boxMap[boxNumber] = boxContent
                    }
                }
            } else {
                let label = step.filter { $0.isLetter }
                let boxNumber = label.lensLibraryHashValue
                let value = Int(step.filter { $0.isNumber })!
                if var boxContent = boxMap[boxNumber] {
                    if let index = boxContent.firstIndex(where: { $0.0 == label }) {
                        boxContent[index].1 = value
                    } else {
                        boxContent.append((label, value))
                    }
                    boxMap[boxNumber] = boxContent
                } else {
                    boxMap[boxNumber] = [(label, value)]
                }
            }
        }
        
        var focusingPowerSum = 0
        for entry in boxMap {
            for (index, slot) in entry.value.enumerated() {
                focusingPowerSum += (entry.key + 1) * (index + 1) * slot.1
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("The focusing power sum is: \(focusingPowerSum)") // 265894
    }
}
