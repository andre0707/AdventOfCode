import Foundation

extension Character {
    var binaryConverted: String {
        switch self {
            case "0": return "0000"
            case "1": return "0001"
            case "2": return "0010"
            case "3": return "0011"
            case "4": return "0100"
            case "5": return "0101"
            case "6": return "0110"
            case "7": return "0111"
            case "8": return "1000"
            case "9": return "1001"
            case "A": return "1010"
            case "B": return "1011"
            case "C": return "1100"
            case "D": return "1101"
            case "E": return "1110"
            case "F": return "1111"
        default: return ""
        }
    }
}

struct Day16 {
    
    struct Packet {
        private var _version: Int = 0
        private var _typeId: Int = 0
        
        private var literalValue: Int? = nil
        private var subPackets: [Packet] = []
        
        
        static func createPacket(from string: Substring) -> (Packet, String.Index) {
            var packet = Packet()
            
            var startIndex = string.startIndex
            var endIndex = string.index(string.startIndex, offsetBy: 3)
            packet._version = Int(string[startIndex ..< endIndex], radix: 2)!
            startIndex = endIndex
            endIndex = string.index(startIndex, offsetBy: 3)
            packet._typeId = Int(string[startIndex ..< endIndex], radix: 2)!
            
            
            switch packet._typeId {
            case 4:
                /// packet is a literal value
                
                var result = ""
                repeat {
                    startIndex = endIndex
                    endIndex = string.index(startIndex, offsetBy: 5)
                    result += string[string.index(startIndex, offsetBy: 1) ..< endIndex]
                } while string[startIndex ..< endIndex].first! == "1"
                
                packet.literalValue = Int(result, radix: 2)!
                return (packet, endIndex)
                
            default:
                /// packet is an operator
                
                startIndex = endIndex
                endIndex = string.index(startIndex, offsetBy: 1)
                let lengthTypeId = Int(string[startIndex ..< endIndex], radix: 2)!
                
                startIndex = endIndex
                
                if lengthTypeId == 0 {
                    endIndex = string.index(startIndex, offsetBy: 15)
                    let subPacketsTotalLength = Int(string[startIndex ..< endIndex], radix: 2)!
                    
                    startIndex = endIndex
                    endIndex = string.index(startIndex, offsetBy: subPacketsTotalLength)
                    
                    while true {
                        let subPacketData = Packet.createPacket(from: string[startIndex ..< endIndex])
                        packet.subPackets.append(subPacketData.0)
                        
                        startIndex = subPacketData.1
                        
                        if startIndex >= endIndex { break }
                        if string[startIndex ..< endIndex].allSatisfy( { $0 == "0" } ) { break }
                    }
                    return (packet, endIndex)
                    
                } else {
                    endIndex = string.index(startIndex, offsetBy: 11)
                    let numberOfSubPackets = Int(string[startIndex ..< endIndex], radix: 2)!
                    
                    startIndex = endIndex
                    endIndex = string.endIndex
                    
                    var counterSubPacketsRead = 0
                    while counterSubPacketsRead < numberOfSubPackets {
                        let subPacketData = Packet.createPacket(from: string[startIndex ..< endIndex])
                        packet.subPackets.append(subPacketData.0)
                        
                        startIndex = subPacketData.1
                        
                        counterSubPacketsRead += 1
                        
                        if startIndex >= endIndex { break }
                        if string[startIndex ..< endIndex].allSatisfy( { $0 == "0" } ) { break }
                    }
                    return (packet, startIndex)
                }
            }
        }
        
        var version: Int {
            _version + subPackets.reduce(into: 0) { result, nextPacket in
                result += nextPacket.version
            }
        }
        
        var value: Int {
            switch _typeId {
            case 0:
                return subPackets.reduce(into: 0) { result, nextPacket in
                    result += nextPacket.value
                }
            case 1:
                return subPackets.reduce(into: 1) { result, nextPacket in
                    result *= nextPacket.value
                }
            case 2:
                return subPackets.map { $0.value }.min()!
            case 3:
                return subPackets.map { $0.value }.max()!
            case 4:
                return literalValue!
            case 5:
                guard subPackets.count == 2 else { return 0 }
                return subPackets[0].value > subPackets[1].value ? 1 : 0
            case 6:
                guard subPackets.count == 2 else { return 0 }
                return subPackets[0].value < subPackets[1].value ? 1 : 0
            case 7:
                guard subPackets.count == 2 else { return 0 }
                return subPackets[0].value == subPackets[1].value ? 1 : 0
            default:
                return 0
            }
        }
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day16", ofType: "txt")!)
            .replacingOccurrences(of: "\n", with: "")
        
        let binaryData = input.reduce(into: "") { result, nextChar in
            result += nextChar.binaryConverted
        }
        
        let packet = Packet.createPacket(from: binaryData[...]).0
        
        
        // MARK: - Task 1
        
        print("The version numbers all added result in: \(packet.version)")
        
        
        // MARK: - Task 2
        
        print("The value of the outer most packet is: \(packet.value)")
    }
}
