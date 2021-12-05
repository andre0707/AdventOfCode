import Foundation

/// See: https://www.redblobgames.com/grids/hexagons/#coordinates-cube
struct CubeCoordinates: Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    init(x: Int, y: Int, z: Int) {
        if x + y + z != 0 { assertionFailure("sum of x, y, z needs to be zero!") }
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    func getNeighbor(on side: HexagonDirection) -> CubeCoordinates {
        switch side {
            case .east:
                return CubeCoordinates(x: self.x + 1, y: self.y - 1, z: self.z)
            case .southEast:
                return CubeCoordinates(x: self.x, y: self.y - 1, z: self.z + 1)
            case .southWest:
                return CubeCoordinates(x: self.x - 1, y: self.y, z: self.z + 1)
            case .west:
                return CubeCoordinates(x: self.x - 1, y: self.y + 1, z: self.z)
            case .nothWest:
                return CubeCoordinates(x: self.x, y: self.y + 1, z: self.z - 1)
            case .northEast:
                return CubeCoordinates(x: self.x + 1, y: self.y, z: self.z - 1)
        }
    }
    
    func getAllNeighbors() -> Set<CubeCoordinates> {
        return Set(HexagonDirection.allCases.map { self.getNeighbor(on: $0) })
    }
}

enum HexagonDirection: String, CaseIterable {
    case east = "ee"
    case southEast = "se"
    case southWest = "sw"
    case west = "ww"
    case nothWest = "nw"
    case northEast = "ne"
}


struct Day24 {
    static func run() {
        let inputFromFile = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day24", ofType: "txt")!)
        
        ///transform input to a form which is easier to parse. se->aa, sw->bb, nw->cc, ne->dd, e->ee, w->ww
        let inputFormatted = inputFromFile.replacingOccurrences(of: "se", with: "aa").replacingOccurrences(of: "sw", with: "bb").replacingOccurrences(of: "nw", with: "cc").replacingOccurrences(of: "ne", with: "dd").replacingOccurrences(of: "e", with: "ee,").replacingOccurrences(of: "w", with: "ww,").replacingOccurrences(of: "aa", with: "se,").replacingOccurrences(of: "bb", with: "sw,").replacingOccurrences(of: "cc", with: "nw,").replacingOccurrences(of: "dd", with: "ne,")
        
        let input = inputFormatted.components(separatedBy: .newlines).map { $0.components(separatedBy: ",").compactMap { HexagonDirection(rawValue: $0) } }.filter { !$0.isEmpty }
        
        var blackFloorTiles = Set<CubeCoordinates>()
        
        
        // MARK: - Task1
        
        for directions in input {
            var cubeCoordinates = CubeCoordinates(x: 0, y: 0, z: 0)
            for hexagonDirection in directions {
                cubeCoordinates = cubeCoordinates.getNeighbor(on: hexagonDirection)
            }
            
            if blackFloorTiles.remove(cubeCoordinates) == nil {
                blackFloorTiles.insert(cubeCoordinates)
            }
        }
        
        print("Task1: There are \(blackFloorTiles.count) black tiles.") //277
        
        
        // MARK: - Task2
        
        for _ in 1 ... 100 {
            var tilesWhichNeedToBeFLipped = Set<CubeCoordinates>()
            for blackTile in blackFloorTiles {
                let neighborTiles = blackTile.getAllNeighbors()
                let blackNeighbors = neighborTiles.intersection(blackFloorTiles)
                let whiteNeighbors = neighborTiles.subtracting(blackNeighbors)
                
                if blackNeighbors.isEmpty || blackNeighbors.count > 2 {
                    tilesWhichNeedToBeFLipped.insert(blackTile)
                }
                
                for whiteNeighbor in whiteNeighbors {
                    let neighbors = whiteNeighbor.getAllNeighbors()
                    if neighbors.intersection(blackFloorTiles).count == 2 {
                        tilesWhichNeedToBeFLipped.insert(whiteNeighbor)
                    }
                }
            }
            
            /// flip the tiles
            for tile in tilesWhichNeedToBeFLipped {
                if blackFloorTiles.remove(tile) == nil {
                    blackFloorTiles.insert(tile)
                }
            }
        }
        
        print("Task2: There are \(blackFloorTiles.count) black niles after 100 days.") //3531
    }
}
