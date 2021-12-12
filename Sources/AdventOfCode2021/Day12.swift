import Foundation

struct Day12 {
    
    class Cave: Identifiable, Comparable {
        static func == (lhs: Day12.Cave, rhs: Day12.Cave) -> Bool {
            lhs.id == rhs.id
        }
        static func <(lhs: Cave, rhs: Cave) -> Bool {
            lhs.id < rhs.id
        }
        
        let id: String
        let isSmallCave: Bool
        
        static var canVisitOneSmalLCaveSecondTime = false
        static var didVisitOneSmallCaveSecondTime: [Bool] = []
        
        static var visitedIds: [Set<String>] = []
        var wasVisited: Bool {
            get {
                if id == "start" { return true }
                if !isSmallCave { return false }
                if Cave.visitedIds.isEmpty {
                    return false
                } else {
                    if Cave.canVisitOneSmalLCaveSecondTime && !Cave.didVisitOneSmallCaveSecondTime[Cave.didVisitOneSmallCaveSecondTime.count - 1] { return false }
                    return Cave.visitedIds[Cave.visitedIds.count - 1].contains(self.id)
                }
            }
            set {
                if !isSmallCave { return }
                if Cave.visitedIds.isEmpty {
                    Cave.visitedIds = [Set([self.id])]
                } else {
                    if Cave.canVisitOneSmalLCaveSecondTime && Cave.visitedIds[Cave.visitedIds.count - 1].contains(self.id) {
                        Cave.didVisitOneSmallCaveSecondTime[Cave.didVisitOneSmallCaveSecondTime.count - 1] = true
                    }
                    Cave.visitedIds[Cave.visitedIds.count - 1].insert(self.id)
                }
            }
        }
        
        private(set) var connectedCaves: [Cave] = []
        
        init(_ id: String) {
            self.id = id
            self.isSmallCave = id.first!.isLowercase
        }
        
        func addConnetion(to cave: Cave) {
            guard !connectedCaves.contains(where: { $0.id == cave.id }) else { return }
            connectedCaves.append(cave)
        }
        
        func sortConnections() {
            connectedCaves.sort()
        }
    }
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day12", ofType: "txt")!)
            .components(separatedBy: .newlines)
        
        var caves = [Cave]()
        for line in input {
            let components = line.components(separatedBy: "-")
            guard components.count == 2 else { continue }
            
            let cave1: Cave
            if let index = caves.firstIndex(where: { $0.id == components[0] }) {
                cave1 = caves[index]
            } else {
                cave1 = Cave(components[0])
                caves.append(cave1)
            }
            let cave2: Cave
            if let index = caves.firstIndex(where: { $0.id == components[1] }) {
                cave2 = caves[index]
            } else {
                cave2 = Cave(components[1])
                caves.append(cave2)
            }
            
            cave1.addConnetion(to: cave2)
            cave2.addConnetion(to: cave1)
        }
        
        caves.forEach { $0.sortConnections() }
        
        
        var validPathCounter = 0
        func walkPath(from cave: Cave) {
            if cave.id == "end" {
                validPathCounter += 1
                return
            }
            cave.wasVisited = true
            
            for possibleNextCave in cave.connectedCaves {
                if possibleNextCave.wasVisited { continue }
                
                Cave.visitedIds.append(Cave.visitedIds.last!)
                Cave.didVisitOneSmallCaveSecondTime.append(Cave.didVisitOneSmallCaveSecondTime.last!)
                walkPath(from: possibleNextCave)
                Cave.visitedIds.removeLast()
                Cave.didVisitOneSmallCaveSecondTime.removeLast()
            }
            
            return
        }
        
        guard caves.contains(where: { $0.id == "end" }) else { return }
        guard let startCave = caves.first(where: { $0.id == "start" }) else { return }
        startCave.wasVisited = true
        Cave.didVisitOneSmallCaveSecondTime = [false]
        
        func start() {
            for cave in startCave.connectedCaves {
                Cave.visitedIds.append(Cave.visitedIds.last!)
                Cave.didVisitOneSmallCaveSecondTime.append(Cave.didVisitOneSmallCaveSecondTime.last!)
                walkPath(from: cave)
                Cave.visitedIds.removeLast()
                Cave.didVisitOneSmallCaveSecondTime.removeLast()
            }
        }
        
        
        // MARK: - Task 1
        
        start()
        print("There are \(validPathCounter) path.")
        
        
        // MARK: - Task 2
        
        validPathCounter = 0
        Cave.canVisitOneSmalLCaveSecondTime = true
        start()
        print("There are \(validPathCounter) path.")
    }
}
