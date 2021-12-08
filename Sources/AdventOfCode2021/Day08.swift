import Foundation

struct Day8 {
    enum SegmentShuffled: String, Comparable {
        static func < (lhs: Day8.SegmentShuffled, rhs: Day8.SegmentShuffled) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        case a, b, c, d, e, f, g
    }
    
    enum Segment: String {
        case a, b, c, d, e, f, g
        
        static let number0: Set<Segment> = [.a, .b, .c, .e, .f, .g]
        static let number1: Set<Segment> = [.c, .f,]
        static let number2: Set<Segment> = [.a, .c, .d, .e, .g]
        static let number3: Set<Segment> = [.a, .c, .d, .f, .g]
        static let number4: Set<Segment> = [.b, .c, .d, .f,]
        static let number5: Set<Segment> = [.a, .b, .d, .f, .g]
        static let number6: Set<Segment> = [.a, .b, .d, .e, .f, .g]
        static let number7: Set<Segment> = [.a, .c, .f]
        static let number8: Set<Segment> = [.a, .b, .c, .d, .e, .f, .g]
        static let number9: Set<Segment> = [.a, .b, .c, .d, .f, .g]
        
        static func resultNumber(for outputArray: [[Segment]]) -> Int {
            var result = ""
            for output in outputArray {
                switch Set(output) {
                case Segment.number0:
                    result += "0"
                    continue
                case Segment.number1:
                    result += "1"
                    continue
                case Segment.number2:
                    result += "2"
                    continue
                case Segment.number3:
                    result += "3"
                    continue
                case Segment.number4:
                    result += "4"
                    continue
                case Segment.number5:
                    result += "5"
                    continue
                case Segment.number6:
                    result += "6"
                    continue
                case Segment.number7:
                    result += "7"
                    continue
                case Segment.number8:
                    result += "8"
                    continue
                case Segment.number9:
                    result += "9"
                    continue
                default:
                    continue
                }
            }
            return Int(result)!
        }
    }
    
    typealias SignalLine = (signalPattern: [Set<SegmentShuffled>], output: [[SegmentShuffled]])
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day08", ofType: "txt")!)
        
        let signalEntries = input
            .components(separatedBy: .newlines)
            .compactMap { line -> SignalLine? in
                guard !line.isEmpty else { return nil }
                let components = line.components(separatedBy: " | ")
                
                let signalPattern = components[0]
                    .components(separatedBy: .whitespaces)
                    .map {
                        Set(
                            $0.map { SegmentShuffled(rawValue: String($0))! }
                        )
                    }
                    .sorted { $0.count < $1.count }
                let output = components[1]
                    .components(separatedBy: .whitespaces)
                    .map {
                        $0.map { SegmentShuffled(rawValue: String($0))! }
                    }
                
                return (signalPattern, output)
            }
        
        
        // MARK: - Task 1
        
        let counter = signalEntries
            .flatMap { $0.output }
            .filter { $0.count <= 4 || $0.count == 7 }
            .count
              
        print("There are \(counter) output entries which are 1, 4, 7 or 8. ")
        
        
        // MARK: - Task 2
        
        /*
         DisplayedNumber -> SegmentCounter
         
         0 -> 6
         1 -> 2
         2 -> 5
         3 -> 5
         4 -> 4
         5 -> 5
         6 -> 6
         7 -> 3
         8 -> 7
         9 -> 6
         
         -----------
         
         1 -> 2
         7 -> 3
         4 -> 4
         2 -> 5
         3 -> 5
         5 -> 5
         0 -> 6
         6 -> 6
         9 -> 6
         8 -> 7
         */
        
        var outputValueSum = 0
        for entry in signalEntries {
            var mapping = [SegmentShuffled : Segment]()
            /// 7 is only number with 3 segments and 1 is only number with 2 segments. Subtracing them results in output a
            let mappedA = entry.signalPattern[1].subtracting(entry.signalPattern[0])
            mapping[mappedA.first!] = .a
            
            /// intersection of the numbers 2, 3, 5 will give all 3 horizontal segments (these 3 numbers are the only ones which have 5 segments each)
            let horizontalSegments = entry.signalPattern[3].intersection(entry.signalPattern[4]).intersection(entry.signalPattern[5])
            
            /// subtracting from horizontal the segments from number 4 and 7 will leave output g
            let mappedG = horizontalSegments.subtracting(entry.signalPattern[1]).subtracting(entry.signalPattern[2])
            mapping[mappedG.first!] = .g
            
            /// subtracting the number 1 segments and all horizontal segments from the number 4 will leave output b
            let mappedB = entry.signalPattern[2].subtracting(entry.signalPattern[0]).subtracting(horizontalSegments)
            mapping[mappedB.first!] = .b
            
            /// We know a and g segments, so horizonal minus these 2 will result in d
            let mappedD = horizontalSegments.subtracting([mapping.first { $0.value == .g }!.key]).subtracting([mapping.first { $0.value == .a }!.key])
            mapping[mappedD.first!] = .d
            
            /// Subtracting all horizontal segements and the number 1 and result for b from 8 will leave output e.
            let mappedE = entry.signalPattern[9].subtracting(horizontalSegments).subtracting(entry.signalPattern[0]).subtracting([mapping.first { $0.value == .b }!.key])
            mapping[mappedE.first!] = .e
            
            /// Intersection from all (number 8) segements with all the ones we have will leave c and f
            let exludingCF = entry.signalPattern[9].intersection(mapping.keys)
            /// For the numbers 0, 6, 9 which all have 6 segements, c will occour 2 times and f 3 times
            let sumOf069 = (Array(entry.signalPattern[6]) + Array(entry.signalPattern[7]) + Array(entry.signalPattern[8]))
                            .filter { !exludingCF.contains($0) }
                            .sorted { $0 < $1 }
            if sumOf069[1] == sumOf069[2] {
                mapping[sumOf069[1]] = .f
                mapping[sumOf069[4]] = .c
            } else {
                mapping[sumOf069[1]] = .c
                mapping[sumOf069[4]] = .f
            }
            
            let mappedOutput = entry.output.map {
                $0.map { mapping[$0]! }
            }
            
            let thisOutputValue = Segment.resultNumber(for: mappedOutput)
            //print(thisOutputValue)
            outputValueSum += thisOutputValue

        }
        
        print("added all output values sums up to: \(outputValueSum)")
    }
}
