import Foundation

extension String {
    func toRange() -> ClosedRange<Int> {
        let components = self.components(separatedBy: "-")
        return Int(components[0])! ... Int(components[1])!
    }
}

typealias Field = (fieldname: String, ranges: [ClosedRange<Int>])

struct Day16 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day16", ofType: "txt")!).components(separatedBy: "\n\n")
                
        let ticketFields = input[0].components(separatedBy: .newlines).map { line -> Field in
            let components = line.components(separatedBy: ": ")
            let fieldDescription = components[0]
            let ranges = components[1].components(separatedBy: " or ").map { range in range.toRange() }
            return (fieldDescription, ranges)
        }
        
        let myTicket = input[1].components(separatedBy: .newlines).last!.components(separatedBy: ",").compactMap { Int($0) }
        let nearbyTickets = input[2].components(separatedBy: .newlines).dropFirst().compactMap { $0.isEmpty ? nil : $0.components(separatedBy: ",").compactMap { Int($0) } }
        
        
        // MARK: - Task1
        var errorNumbers: [Int] = []
        let validRanges = ticketFields.flatMap { $0.ranges }
        for ticket in nearbyTickets {
            for number in ticket {
                if !validRanges.contains(where: { $0.contains(number) }) {
                    errorNumbers.append(number)
                    break
                }
            }
        }
        
        print("Task1: The ticket scanning error rate is: \(errorNumbers.reduce(0, +))")
        
        
        // MARK: - Task2
        let validTickets = nearbyTickets.filter { ticket in
            return ticket.allSatisfy( { number in validRanges.contains(where: { range in range.contains(number) })})
        }
        //print("total: \(nearbyTickets.count), valid: \(validTickets.count), invalid: \(nearbyTickets.count - validTickets.count)")
        
        var mapping: [String: Int] = [:]
        while true {
            if mapping.count == ticketFields.count { break }
            var ambiguousIndices: [Int] = []
            for index in 0 ..< ticketFields.count {
                let column = validTickets.map { $0[index] }
                let field = ticketFields.filter { field in
                    column.allSatisfy { columnValue in
                        field.ranges.contains { range in
                            range.contains(columnValue) && mapping[field.fieldname] == nil
                        }
                    }
                }
                switch field.count {
                    case 0:
                        continue //element is already handeled
                    case 1:
                        mapping[field[0].fieldname] = index
                        continue
                    default:
                        ambiguousIndices.append(index)
                        continue
                }
            }
                        
            for index in ambiguousIndices {
                let column = validTickets.map { $0[index] }
                let field = ticketFields.filter { field in
                    column.allSatisfy { columnValue in
                        field.ranges.contains { range in
                            range.contains(columnValue) && mapping[field.fieldname] == nil
                        }
                    }
                }
                switch field.count {
                    case 0:
                        fatalError("why is there no element")
                        continue
                    case 1:
                        mapping[field[0].fieldname] = index
                        continue
                    default:
                        continue
                }
            }
        }
        
        
        var result = 1
        for field in ticketFields {
            if !field.fieldname.starts(with: "departure") { continue }
            result *= myTicket[mapping[field.0]!]
        }
        print("Task2: result of multiplying all depature values is: \(result)")
        
        //print("Task2: result of multiplying all depature values is: \(fields.filter { $0.fieldname.starts(with: "departure") }.reduce(into: 1, { $0 *= myTicket[mapping[$1.fieldname]!] }))")
    }
}
