import Foundation


struct Day11 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day11", ofType: "txt")!).components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let seats = input.map { $0.map{ String($0) } }
        
        func numberOfOccupiedSeats(for rowIndex: Int, seatIndex: Int, in seats: [[String]]) -> Int {
            var occupiedSeats = 0
            for row in (rowIndex - 1 ... rowIndex + 1) {
                if row < 0 { continue }
                if row >= seats.count { continue }
                
                for column in (seatIndex - 1 ... seatIndex + 1) {
                    if column < 0 { continue }
                    if column >= seats[row].count { continue }
                    
                    if row == rowIndex && column == seatIndex { continue } // do not count self
                    
                    if seats[row][column] == "#" {
                        occupiedSeats += 1
                    }
                }
            }
            return occupiedSeats
        }
        
        
        
        func visibleOccupiedSeats(rowIndex: Int, columnIndex: Int, in seats: [[String]]) -> Int {
            var occupiedSeats = 0
            
            var rowToCheck = rowIndex - 1
            var columnToCheck = columnIndex - 1
            upLeftLoop: while rowToCheck >= 0 && columnToCheck >= 0  {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break upLeftLoop
                    case "#":
                        occupiedSeats += 1
                        break upLeftLoop
                    case ".":
                        rowToCheck -= 1
                        columnToCheck -= 1
                        continue upLeftLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex - 1
            columnToCheck = columnIndex
            upLoop: while rowToCheck >= 0 {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break upLoop
                    case "#":
                        occupiedSeats += 1
                        break upLoop
                    case ".":
                        rowToCheck -= 1
                        continue upLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex - 1
            columnToCheck = columnIndex + 1
            upRightLoop: while rowToCheck >= 0 && columnToCheck < seats[rowToCheck].count {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break upRightLoop
                    case "#":
                        occupiedSeats += 1
                        break upRightLoop
                    case ".":
                        rowToCheck -= 1
                        columnToCheck += 1
                        continue upRightLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex
            columnToCheck = columnIndex - 1
            leftLoop: while columnToCheck >= 0 {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break leftLoop
                    case "#":
                        occupiedSeats += 1
                        break leftLoop
                    case ".":
                        columnToCheck -= 1
                        continue leftLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex
            columnToCheck = columnIndex + 1
            rightLoop: while columnToCheck < seats[rowToCheck].count {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break rightLoop
                    case "#":
                        occupiedSeats += 1
                        break rightLoop
                    case ".":
                        columnToCheck += 1
                        continue rightLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex + 1
            columnToCheck = columnIndex - 1
            downLeftLoop: while rowToCheck < seats.count && columnToCheck >= 0 {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break downLeftLoop
                    case "#":
                        occupiedSeats += 1
                        break downLeftLoop
                    case ".":
                        rowToCheck += 1
                        columnToCheck -= 1
                        continue downLeftLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex + 1
            columnToCheck = columnIndex
            downLoop: while rowToCheck < seats.count {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break downLoop
                    case "#":
                        occupiedSeats += 1
                        break downLoop
                    case ".":
                        rowToCheck += 1
                        continue downLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            rowToCheck = rowIndex + 1
            columnToCheck = columnIndex + 1
            downRightLoop: while rowToCheck < seats.count && columnToCheck < seats[rowToCheck].count {
                switch seats[rowToCheck][columnToCheck] {
                    case "L":
                        break downRightLoop
                    case "#":
                        occupiedSeats += 1
                        break downRightLoop
                    case ".":
                        rowToCheck += 1
                        columnToCheck += 1
                        continue downRightLoop
                    default:
                        fatalError("wrong char")
                }
            }
            
            return occupiedSeats
        }
        
        
        // seems to be way slower than visibleOccupiedSeats. Not sure why
        func visibleOccupiedSeats2(rowIndex: Int, columnIndex: Int, in seats: [[String]]) -> Int {
            var occupiedSeats = 0
            
            enum DirectionsToCheck: CaseIterable {
                case tl, t, tr, l, r, bl, b, br
            }
            
            DirectionsToCheck.allCases.forEach { direction in
                var rowToCheck = rowIndex + ([.tl, .t, .tr].contains(direction) ? -1 : ( [.bl, .b, .br].contains(direction) ? 1 : 0))
                var columnToCheck = columnIndex + ([.tl, .l, .bl].contains(direction) ? -1 : ( [.tr, .r, .br].contains(direction) ? 1 : 0))
                
                Runningloop: while (rowToCheck >= 0 && rowToCheck < seats.count && columnToCheck >= 0 && columnToCheck < seats[columnToCheck].count) {
                    switch seats[rowToCheck][columnToCheck] {
                        case "L":
                            break Runningloop
                        case "#":
                            occupiedSeats += 1
                            break Runningloop
                        case ".":
                            rowToCheck += ([.tl, .t, .tr].contains(direction) ? -1 : ( [.bl, .b, .br].contains(direction) ? 1 : 0))
                            columnToCheck += ([.tl, .l, .bl].contains(direction) ? -1 : ( [.tr, .r, .br].contains(direction) ? 1 : 0))
                            continue Runningloop
                        default:
                            fatalError("wrong char")
                    }
                }
            }
            
            return occupiedSeats
        }
        
        
        func changeSeat(at rowIndex: Int, columnIndex: Int, in seats: inout [[String]]) {
            switch seats[rowIndex][columnIndex] {
                case "#":
                    seats[rowIndex][columnIndex] = "L"
                    return
                case "L":
                    seats[rowIndex][columnIndex] = "#"
                    return
                default:
                    fatalError("unexpected seat value")
            }
        }
        
        
        func applySeatingRulesTask1(seats: inout [[String]]) {
            var seatsToChange: [(row: Int, column: Int)] = []
            for (rowIndex, row) in seats.enumerated() {
                for (seatIndex, seat) in row.enumerated() {
                    let occupiedSeats = numberOfOccupiedSeats(for: rowIndex, seatIndex: seatIndex, in: seats)
                    if (seat == "L" && occupiedSeats == 0) || (seat == "#" && occupiedSeats >= 4) {
                        seatsToChange.append((rowIndex, seatIndex))
                    }
                }
            }
            seatsToChange.forEach {
                changeSeat(at: $0.row, columnIndex: $0.column, in: &seats)
            }
        }
        
        
        func task1() {
            var task1Seats = seats
            var repeatings = 0
            var occupiedSeatsBefore = 0
            var occupiedSeats = 0
            repeat {
                repeatings += 1
                occupiedSeatsBefore = occupiedSeats
                applySeatingRulesTask1(seats: &task1Seats)
                occupiedSeats = task1Seats.reduce(into: 0) { $0 += $1.filter { $0 == "#" }.count }
            } while (occupiedSeats != occupiedSeatsBefore)
            
            print("Task1: There are \(occupiedSeats) occupied seats. It took \(repeatings) repeatings to get there.")
        }
        
        
        func applySeatingRulesTask2(seats: inout [[String]]) {
            var seatsToChange: [(row: Int, column: Int)] = []
            for (rowIndex, row) in seats.enumerated() {
                for (seatIndex, seat) in row.enumerated() {
                    let occupiedSeats = visibleOccupiedSeats(rowIndex: rowIndex, columnIndex: seatIndex, in: seats)
                    if (seat == "L" && occupiedSeats == 0) || (seat == "#" && occupiedSeats >= 5) {
                        seatsToChange.append((rowIndex, seatIndex))
                    }
                }
            }
            seatsToChange.forEach {
                changeSeat(at: $0.row, columnIndex: $0.column, in: &seats)
            }
        }
        
        
        func task2() {
            var task2Seats = seats
            var repeatings = 0
            var occupiedSeatsBefore = 0
            var occupiedSeats = 0
            repeat {
                repeatings += 1
                occupiedSeatsBefore = occupiedSeats
                applySeatingRulesTask2(seats: &task2Seats)
                occupiedSeats = task2Seats.reduce(into: 0) { $0 += $1.filter { $0 == "#" }.count }
            } while (occupiedSeats != occupiedSeatsBefore)
            
            print("Task2: There are \(occupiedSeats) occupied seats. It took \(repeatings) repeatings to get there.")
            
        }
        
        
        task1()
        task2()
        print("done")
    }
}
