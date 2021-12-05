import Foundation


extension Int {
    func bitRepresentation(fillZerosToLength: Int) -> String {
        let bitString = String(self, radix: 2)
        return String(repeating: "0", count: (fillZerosToLength) - bitString.count) + bitString
    }
    
    func maskWith(mask: String) -> Int {
        let bitString = self.bitRepresentation(fillZerosToLength: mask.count)
        
        var result = ""
        for i in (0 ..< mask.count) {
            let index = mask.index(mask.startIndex, offsetBy: i)
            switch mask[index] {
                case "0", "1":
                    result += mask[index ... index]
                    continue
                default:
                    result += bitString[index ... index]
                    continue
            }
        }
        
        return Int(strtoul(result, nil, 2))
    }
    
    
    func maskWith2(mask: String) -> [Int] {
        let bitString = self.bitRepresentation(fillZerosToLength: mask.count)
        
        var result = ""
        for i in (0 ..< mask.count) {
            let index = mask.index(mask.startIndex, offsetBy: i)
            switch mask[index] {
                case "0":
                    result += bitString[index ... index]
                    continue
                default:
                    result += mask[index ... index]
                    continue
            }
        }
        
        func resolve(string: String, result: inout [Int]) {
            for i in ( 0 ..< string.count) {
                let index = string.index(string.startIndex, offsetBy: i)
                switch string[index] {
                    case "0", "1":
                        continue
                    default:
                        var newString = string
                        newString.replaceSubrange(index ... index, with: "0")
                        resolve(string: newString, result: &result)
                        newString.replaceSubrange(index ... index, with: "1")
                        resolve(string: newString, result: &result)
                        return
                }
            }
            result.append(Int(strtoul(string, nil, 2)))
        }
        
        var addresses: [Int] = []
        resolve(string: result, result: &addresses)
        return addresses
    }
}


struct Day14 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day14", ofType: "txt")!).components(separatedBy: .newlines).filter { !$0.isEmpty }.map { line -> (command: String, value: String) in
            let components = line.components(separatedBy: " = ")
            return (command: components[0], value: components[1])
        }
        
        
        // MARK: - Task1
        
        var mem: [Int : Int] = [:]
        var mask = ""
        for line in input {
            switch line.command {
                case "mask":
                    mask = line.value
                    continue
                case var com where com.contains("mem"):
                    com.removeFirst(4)
                    com.removeLast()
                    mem[Int(com)!] = Int(line.value)!.maskWith(mask: mask)
                    continue
                default:
                    assertionFailure("unknown command")
            }
        }
        
        print("Task1: \(mem.reduce(0, { $0 + $1.value }))")
        
        
        
        // MARK: - Task2
        
        mem = [:]
        mask = ""
        for line in input {
            switch line.command {
                case "mask":
                    mask = line.value
                    continue
                case var com where com.contains("mem"):
                    com.removeFirst(4)
                    com.removeLast()
                    
                    let adresses = Int(com)!.maskWith2(mask: mask)
                    adresses.forEach { mem[$0] = Int(line.value) }
                    
                    continue
                default:
                    assertionFailure("unknown command")
            }
        }
        
        print("Task2: \(mem.reduce(0, { $0 + $1.value }))")
        
    }
}

