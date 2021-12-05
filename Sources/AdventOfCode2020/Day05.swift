import Foundation

enum SeatError: Error {
    case wrongData
    case wrongInstruction
}

struct Seat {
    let row: Int
    let column: Int
    
    init?(from string: String) throws {
        if string.count != 10 { throw SeatError.wrongData }
        
        var rowInterval: ClosedRange<Int> = 0 ... 127
        var columnInterval: ClosedRange<Int> = 0 ... 7
        
        for char in string {
            switch char {
                case "F":
                    rowInterval = rowInterval.lowerBound ... ((rowInterval.upperBound + rowInterval.lowerBound) / 2 )
                case "B":
                    rowInterval = (rowInterval.lowerBound + ((rowInterval.upperBound - rowInterval.lowerBound) / 2 + 1)) ... rowInterval.upperBound
                case "L":
                    columnInterval = columnInterval.lowerBound ... ((columnInterval.upperBound + columnInterval.lowerBound) / 2 )
                case "R":
                    columnInterval = (columnInterval.lowerBound + ((columnInterval.upperBound - columnInterval.lowerBound) / 2 + 1)) ... columnInterval.upperBound
                default:
                    throw SeatError.wrongInstruction
            }
        }
        
        self.row = rowInterval.lowerBound
        self.column = columnInterval.lowerBound
    }
    
    var seatID: Int { return self.row * 8 + self.column }
}



struct Day5 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day05", ofType: "txt")!)
        let inputLines = input.components(separatedBy: .newlines)
        
        let seatIDs = inputLines.compactMap { try? Seat(from: $0)?.seatID }
        let highestSeatID = seatIDs.max() ?? 0
        print("The highest seat ID is: \(highestSeatID)")
        
        
        for seatID in 1 ..< highestSeatID {
            if seatIDs.contains(seatID) || !seatIDs.contains(seatID + 1) || !seatIDs.contains(seatID - 1) { continue }
            
            print("My seat ID is: \(seatID)")
            break
        }
    }
}
