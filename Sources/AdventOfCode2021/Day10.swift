import Foundation

struct Day10 {
    
    enum Direction {
        case open, close
    }
    
    enum Chunk {
        case round(Direction)
        case square(Direction)
        case curly(Direction)
        case angle(Direction)
        
        init?(_ value: Character) {
            switch value {
            case "(":
                self = Chunk.round(.open)
            case ")":
                self = Chunk.round(.close)
            case "[":
                self = Chunk.square(.open)
            case "]":
                self = Chunk.square(.close)
            case "{":
                self = Chunk.curly(.open)
            case "}":
                self = Chunk.curly(.close)
            case "<":
                self = Chunk.angle(.open)
            case ">":
                self = Chunk.angle(.close)
            default:
                return nil
            }
        }
        
        func closes(_ rhs: Chunk) -> Bool {
            switch (self, rhs) {
            case (.round(let lhsValue), .round(let rhsValue)):
                return lhsValue != rhsValue
            case (.square(let lhsValue), .square(let rhsValue)):
                return lhsValue != rhsValue
            case (.curly(let lhsValue), .curly(let rhsValue)):
                return lhsValue != rhsValue
            case (.angle(let lhsValue), .angle(let rhsValue)):
                return lhsValue != rhsValue
            default:
                return false
            }
        }
        
        static func checkSyntax(for chunks: [Chunk]) throws {
            var stack: [Chunk] = []
            var incompletion: [Chunk] = []
            for chunk in chunks {
                switch chunk {
                case .round(let direction):
                    if direction == .open {
                        stack.append(chunk)
                    } else {
                        if stack.isEmpty { throw ChunkError.wrongData }
                        if !chunk.closes(stack.removeLast()) { throw ChunkError.corrupted(chunk) }
                    }
                case .square(let direction):
                    if direction == .open {
                        stack.append(chunk)
                    } else {
                        if stack.isEmpty { throw ChunkError.wrongData }
                        if !chunk.closes(stack.removeLast()) { throw ChunkError.corrupted(chunk) }
                    }
                case .curly(let direction):
                    if direction == .open {
                        stack.append(chunk)
                    } else {
                        if stack.isEmpty { throw ChunkError.wrongData }
                        if !chunk.closes(stack.removeLast()) { throw ChunkError.corrupted(chunk) }
                    }
                case .angle(let direction):
                    if direction == .open {
                        stack.append(chunk)
                    } else {
                        if stack.isEmpty { throw ChunkError.wrongData }
                        if !chunk.closes(stack.removeLast()) { throw ChunkError.corrupted(chunk) }
                    }
                }
            }
            
            for element in stack.reversed() {
                switch element {
                case .round:
                    incompletion.append(.round(.close))
                case .square:
                    incompletion.append(.square(.close))
                case .curly:
                    incompletion.append(.curly(.close))
                case .angle:
                    incompletion.append(.angle(.close))
                }
            }
            
            if !incompletion.isEmpty {
                var incompletionScore = 0
                for incomplete in incompletion {
                    incompletionScore *= 5
                    switch incomplete {
                    case .round:
                        incompletionScore += 1
                    case .square:
                        incompletionScore += 2
                    case .curly:
                        incompletionScore += 3
                    case .angle:
                        incompletionScore += 4
                    }
                }
                throw ChunkError.incomplete(incompletionScore)
            }
        }
    }
    
    enum ChunkError: Error {
        case wrongData
        case incomplete(Int)
        case corrupted(Chunk)
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day10", ofType: "txt")!)
            .components(separatedBy: .newlines)
        
        let lines = input.map { $0.compactMap { Chunk($0) } }
        
        var syntaxErrorScore = 0
        var incompletionScores: [Int] = []
        for line in lines {
            do {
                try Chunk.checkSyntax(for: line)
            } catch(let error) {
                if let error = error as? ChunkError {
                    switch error {
                    case .incomplete(let score):
                        incompletionScores.append(score)
                    case .corrupted(let chunk):
                        switch chunk {
                        case .round:
                            syntaxErrorScore += 3
                        case .square:
                            syntaxErrorScore += 57
                        case .curly:
                            syntaxErrorScore += 1197
                        case .angle:
                            syntaxErrorScore += 25137
                        }
                    case .wrongData:
                        continue
                    }
                }
            }
        }
        
        // MARK: - Task 1
        
        print("The syntax error score is: \(syntaxErrorScore)")
        
        // MARK: - Task 2
        
        incompletionScores.sort()
        print("The middle score is: \(incompletionScores[incompletionScores.count / 2])")
    }
}
