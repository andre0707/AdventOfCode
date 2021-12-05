import Foundation


extension Array where Element == String {
    mutating func rotateClockwise() {
        self = rotatingClockwise()
    }
    
    func rotatingClockwise() -> [String] {
        var newArray: [String] = []
        for line in self {
            for (index, char) in line.enumerated() {
                if index >= newArray.count {
                    newArray.append(String(char))
                } else {
                    newArray[index] = String(char) + newArray[index]
                }
            }
        }
        return newArray
    }
    
    mutating func rotateCounterClockwise() {
        self = rotatingCounterClockwise()
    }
    
    func rotatingCounterClockwise() -> [String] {
        var newArray: [String] = []
        for line in self {
            for (index, char) in line.reversed().enumerated() {
                if index >= newArray.count {
                    newArray.append(String(char))
                } else {
                    newArray[index] += String(char)
                }
            }
        }
        return newArray
    }
    
    mutating func addArrayOnRightSide(startRow: Int, array: [String]) {
        for (index, element) in array.enumerated() {
            let insertInRow = startRow + index
            if insertInRow < self.count {
                self[insertInRow].append(element)
            } else {
                self.append(element)
            }
        }
    }
    
    mutating func flipHorizontal() {
        self = flippingHorizontal()
    }
    
    func flippingHorizontal() -> [String] {
        return self.reversed()
    }
    
    mutating func flipVertical() {
        self = flippingVertical()
    }
    
    func flippingVertical() -> [String] {
        var result = [String]()
        for i in 0 ..< self.count {
            result.append(String(self[i].reversed()))
        }
        return result
    }
}


typealias MonsterLocation = (row: Int, column: Int) // this is the top left position of where the monster begins. it is then 20 wide and 3 high. so endpoint is (row + 2, column + 20)

func findMonster(in image: [String]) -> [MonsterLocation] {
    /*
    let monster: [String] = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   "
    ]
    */
    let monsterRegex = [
        "[\\.#]{18}#[\\.#]",
        "#[\\.#]{4}##[\\.#]{4}##[\\.#]{4}###",
        "[\\.#]#[\\.#]{2}#[\\.#]{2}#[\\.#]{2}#[\\.#]{2}#[\\.#]{2}#[\\.#]{3}"
    ]
    
    /// return ranges in which the pattern occurs in the text. If there is a known range, pass it in to check for another pattern in this range
    func matches(for pattern: String, in text: String, whithRange: NSRange? = nil) -> [NSRange] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: text, options: [], range: whithRange ?? NSRange(location: 0, length: text.count))
        
        return matches.map { $0.range }
    }
    
    var monsterLocations: [MonsterLocation] = []
    
    for (index, line) in image.enumerated() {
        /// start with the middle line of the monster to reduce the amount of hits
        let matchingRanges = matches(for: monsterRegex[1], in: line)
        for matchingRange in matchingRanges {
            /// if the middle line of the monster hit, check if the complete monster hit as well
            if index == 0 || index >= image.count - 2 { continue }
            if !matches(for: monsterRegex[0], in: image[index - 1], whithRange: matchingRange).isEmpty && !matches(for: monsterRegex[2], in: image[index + 1], whithRange: matchingRange).isEmpty {
                /// found a valid monster. Remember the location
                monsterLocations.append((row: index - 1, column: matchingRange.location))
            }
        }
    }
    return monsterLocations
}


typealias TileEdge = String

enum Direction {
    case leading, top, trailing, bottom
}

struct Tile {
    let id: Int
    
    var leading: TileEdge
    var top: TileEdge
    var trailing: TileEdge
    var bottom: TileEdge
    
    var leadingNeighbor: Int? = nil
    var topNeighbor: Int? = nil
    var trailingNeighbor: Int? = nil
    var bottomNeighbor: Int? = nil
    
    var neighbors: [Int] = []
        
    var pictureData: [String] = []
    
    init?(with completeTile: String) {
        if completeTile.isEmpty { return nil }
        
        var components = completeTile.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let tileIdString = components.removeFirst()
        self.id = Int(tileIdString[tileIdString.index(tileIdString.startIndex, offsetBy: 5) ... tileIdString.index(tileIdString.endIndex, offsetBy: -2)])!
        
        var leading = ""
        var trailing = ""
        for component in components {
            leading += String(component.first!)
            trailing += String(component.last!)
            
            let pictureLine = String(component[component.index(after: component.startIndex) ..< component.index(before: component.endIndex)])
            self.pictureData.append(pictureLine)
        }
        self.pictureData.removeFirst() //components still includes the first line which is just for checks. So remove that line in picture data
        self.pictureData.removeLast() //components still includes the last line which is just for checks. So remove that line in picture data
        self.leading = leading
        self.top = components.first!
        self.trailing = trailing
        self.bottom = components.last!
    }
    
    /// Checks if self has a common edge with the passed in tile. If so, it will return which edge it is
    mutating private func commonEdge(withTile tile: Tile) -> Direction? {
        //if self.leadingNeighbor == nil {
            if self.leading == tile.leading || self.leading == tile.top || self.leading == tile.trailing || self.leading == tile.bottom {
                self.neighbors.append(tile.id)
                self.leadingNeighbor = tile.id
                return Direction.leading
            }
            let leadingReversed = TileEdge(self.leading.reversed())
            if leadingReversed == tile.leading || leadingReversed == tile.top || leadingReversed == tile.trailing || leadingReversed == tile.bottom {
                self.neighbors.append(tile.id)
                self.flipHorizontal()
                self.leadingNeighbor = tile.id
                return Direction.leading
            }
        //}
        
        //if self.topNeighbor == nil {
            if self.top == tile.leading || self.top == tile.top || self.top == tile.trailing || self.top == tile.bottom {
                self.neighbors.append(tile.id)
                self.topNeighbor = tile.id
                return Direction.top
            }
            let topReversed = TileEdge(self.top.reversed())
            if topReversed == tile.leading || topReversed == tile.top || topReversed == tile.trailing || topReversed == tile.bottom {
                self.neighbors.append(tile.id)
                self.flipVertical()
                self.topNeighbor = tile.id
                return Direction.top
            }
        //}
        
        //if self.trailingNeighbor == nil {
            if self.trailing == tile.leading || self.trailing == tile.top || self.trailing == tile.trailing || self.trailing == tile.bottom {
                self.neighbors.append(tile.id)
                self.trailingNeighbor = tile.id
                return Direction.trailing
            }
            let trailingReversed = TileEdge(self.trailing.reversed())
            if trailingReversed == tile.leading || trailingReversed == tile.top || trailingReversed == tile.trailing || trailingReversed == tile.bottom {
                self.neighbors.append(tile.id)
                self.flipHorizontal()
                self.trailingNeighbor = tile.id
                return Direction.trailing
            }
        //}
        
        //if self.bottomNeighbor == nil {
            if self.bottom == tile.leading || self.bottom == tile.top || self.bottom == tile.trailing || self.bottom == tile.bottom {
                self.neighbors.append(tile.id)
                self.bottomNeighbor = tile.id
                return Direction.bottom
            }
            let bottomReversed = TileEdge(self.bottom.reversed())
            if bottomReversed == tile.leading || bottomReversed == tile.top || bottomReversed == tile.trailing || bottomReversed == tile.bottom {
                self.neighbors.append(tile.id)
                self.flipVertical()
                self.bottomNeighbor = tile.id
                return Direction.bottom
            }
        //}
        
        return nil
    }
    
    /// Checks self with all passed in tiles for common edges.
    /// Corner tiles will return 2
    /// Side tiles will return 1
    /// All other tiles will return 4
    mutating func numberOfCommonEdges(with tiles: [Tile]) -> Int {
        var commonEdges: [(Direction, Tile)] = []
        
        for tile in tiles {
            if tile.id == self.id { continue }
            guard let commonEdge = self.commonEdge(withTile: tile) else { continue }
            commonEdges.append((commonEdge, tile))
        }
        
        return commonEdges.count
    }
    
    mutating func rotateClockwise() {
        let temp = self.leading
        self.leading = self.bottom
        self.bottom = String(self.trailing.reversed())
        self.trailing = self.top
        self.top = String(temp.reversed())
        
        let tempNeighbour = self.leadingNeighbor
        self.leadingNeighbor = self.bottomNeighbor
        self.bottomNeighbor = self.trailingNeighbor
        self.trailingNeighbor = self.topNeighbor
        self.topNeighbor = tempNeighbour
        
        self.pictureData.rotateClockwise()
    }
    
    mutating func rotateCounterClockwise() {
        let temp = self.leading
        self.leading = String(self.top.reversed())
        self.top = self.trailing
        self.trailing = String(self.bottom.reversed())
        self.bottom = temp
        
        let tempNeighbour = self.leadingNeighbor
        self.leadingNeighbor = self.topNeighbor
        self.topNeighbor = self.trailingNeighbor
        self.trailingNeighbor = self.bottomNeighbor
        self.bottomNeighbor = tempNeighbour
        
        self.pictureData.rotateCounterClockwise()
    }
    
    mutating func flipHorizontal() {
        swap(&self.topNeighbor, &self.bottomNeighbor)
        swap(&self.top, &self.bottom)
        self.leading = String(self.leading.reversed())
        self.trailing = String(self.trailing.reversed())
        
        self.pictureData.flipHorizontal()
    }
    
    mutating func flipVertical() {
        swap(&self.leadingNeighbor, &self.trailingNeighbor)
        swap(&self.leading, &self.trailing)
        self.top = String(self.top.reversed())
        self.bottom = String(self.bottom.reversed())
        
        self.pictureData.flipVertical()
    }
    
    func isNeighborTo(tileWithId: Int) -> Bool { return self.neighbors.contains(tileWithId) }
}


struct Day20 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day20", ofType: "txt")!).components(separatedBy: "\n\n")
        
        var tiles = input.compactMap { Tile(with: $0) }
        
        var cornerTiles: [Tile] = []
        var sideTiles: [Tile] = []
        var innerTiles: [Tile] = []
        for i in 0 ..< tiles.count {
            switch tiles[i].numberOfCommonEdges(with: tiles) {
                case 2:
                    cornerTiles.append(tiles[i])
                case 3:
                    sideTiles.append(tiles[i])
                case 4:
                    innerTiles.append(tiles[i])
                default:
                    fatalError("Error getting number of common edges for tile with id: \(tiles[i].id)")
            }
        }
        
        
        // MARK: - Task1
        
        print("Task1: The product of the IDs of the 4 corner tiles is: \(cornerTiles.reduce(into: 1, { $0 *= $1.id }))") //16192267830719
        
        
        // MARK: - Task2
        
        //todo: 1229 is expected to be an inner tile
        if cornerTiles.firstIndex(where: { $0.id == 1229}) != nil { print("1229 is corner")}
        if sideTiles.firstIndex(where: { $0.id == 1229}) != nil { print("1229 is side")}
        if innerTiles.firstIndex(where: { $0.id == 1229}) != nil { print("1229 is inner")}
        
        //let neighborsOf1229_corner = cornerTiles.filter{ $0.neighbors.contains(1229) }.map { $0.id}
        //let neighborsOf1229_sides = sideTiles.filter{ $0.neighbors.contains(1229) }.map { $0.id}
        //let neighborsOf1229_inner = innerTiles.filter{ $0.neighbors.contains(1229) }.map { $0.id}
        
        
        
        var completePicture = [String]()
        
        var grid: [[Int]] = []
        var currentRow = [Int]()
        var usedCorners = [Int]()
        var usedSides = [Int]()
        
        var counterRotations = 0
        /// set the first corner tile at top left position
        usedCorners.append(cornerTiles[0].id)
        currentRow.append(cornerTiles[0].id)
        while cornerTiles[0].leadingNeighbor != nil || cornerTiles[0].topNeighbor != nil {
            cornerTiles[0].rotateClockwise()
            counterRotations += 1
            if counterRotations > 3 {
                /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                cornerTiles[0].flipVertical()
                counterRotations = 0
            }
        }
        counterRotations = 0
        completePicture = cornerTiles[0].pictureData
        
        var currentLeadingNeighbor: Int? = cornerTiles[0].id
        var tileMustHaveId = cornerTiles[0].trailingNeighbor!
        /// next step is to add as many side tiles as needed
        for _ in 0 ..< sideTiles.count / 4 {
            if sideTiles.filter({$0.id == tileMustHaveId && !usedSides.contains($0.id)}).count != 1 { assertionFailure("row 1 has a not unique side tile")}
            let indexTrailingNeighbour = sideTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedSides.contains($0.id) })!
            while sideTiles[indexTrailingNeighbour].leadingNeighbor != currentLeadingNeighbor || sideTiles[indexTrailingNeighbour].topNeighbor != nil {
                sideTiles[indexTrailingNeighbour].rotateClockwise()
                counterRotations += 1
                if counterRotations > 3 {
                    /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                    sideTiles[indexTrailingNeighbour].flipVertical()
                    counterRotations = 0
                }
            }
            counterRotations = 0
            completePicture.addArrayOnRightSide(startRow: 0, array: sideTiles[indexTrailingNeighbour].pictureData)
            
            usedSides.append(sideTiles[indexTrailingNeighbour].id)
            currentLeadingNeighbor = sideTiles[indexTrailingNeighbour].id
            tileMustHaveId = sideTiles[indexTrailingNeighbour].trailingNeighbor!
            currentRow.append(sideTiles[indexTrailingNeighbour].id)
        }
        
        /// next step is to add the top right corner
        //if sideTiles.filter({$0.id == tileMustHaveId && !usedCorners.contains($0.id)}).count != 1 { assertionFailure("row 1 has a not unique corner tile")}
        let trCornerTileIndex = cornerTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedCorners.contains($0.id) })!
        currentRow.append(cornerTiles[trCornerTileIndex].id)
        usedCorners.append(cornerTiles[trCornerTileIndex].id)
        while cornerTiles[trCornerTileIndex].leadingNeighbor != currentLeadingNeighbor || cornerTiles[trCornerTileIndex].topNeighbor != nil {
            cornerTiles[trCornerTileIndex].rotateClockwise()
            if counterRotations > 3 {
                /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                cornerTiles[trCornerTileIndex].flipVertical()
                counterRotations = 0
            }
        }
        counterRotations = 0
        completePicture.addArrayOnRightSide(startRow: 0, array: cornerTiles[trCornerTileIndex].pictureData)
        
        grid.append(currentRow)
        currentRow.removeAll()
        
        /// next step is to add all the next rows which lay in between to top and bottom row
        let pictureHeight = cornerTiles[0].pictureData.count
        var currentTopNeighborID = cornerTiles[0].id
        tileMustHaveId = cornerTiles[0].bottomNeighbor!
        var startRowCompletePicture = completePicture.count
        for i in 0 ..< sideTiles.count / 4 {
            startRowCompletePicture += i * pictureHeight
            /// start with a side tile
            let leadingSideTileIndex = sideTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedSides.contains($0.id) })!
            while sideTiles[leadingSideTileIndex].topNeighbor != currentTopNeighborID || sideTiles[leadingSideTileIndex].leadingNeighbor != nil {
                sideTiles[leadingSideTileIndex].rotateClockwise()
                counterRotations += 1
                if counterRotations > 3 {
                    /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                    sideTiles[leadingSideTileIndex].flipVertical()
                    counterRotations = 0
                }
            }
            counterRotations = 0
            completePicture.append(contentsOf: sideTiles[leadingSideTileIndex].pictureData)
            
            usedSides.append(sideTiles[leadingSideTileIndex].id)
            currentLeadingNeighbor = sideTiles[leadingSideTileIndex].id
            currentRow.append(sideTiles[leadingSideTileIndex].id)
            tileMustHaveId = sideTiles[leadingSideTileIndex].trailingNeighbor!
            
            /// add all inside tiles for the current row
            let size = (sideTiles.count * sideTiles.count / 16)
            for j in 1 ... size {
                currentTopNeighborID = grid[i][j]
                let innerTileIndex = innerTiles.firstIndex(where: { $0.id == tileMustHaveId })!
                while innerTiles[innerTileIndex].topNeighbor != currentTopNeighborID || innerTiles[innerTileIndex].leadingNeighbor != currentLeadingNeighbor {
                    innerTiles[innerTileIndex].rotateClockwise()
                    counterRotations += 1
                    if counterRotations > 3 {
                        /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                        innerTiles[innerTileIndex].flipVertical()
                        counterRotations = 0
                    }
                }
                counterRotations = 0
                completePicture.addArrayOnRightSide(startRow: startRowCompletePicture, array: innerTiles[innerTileIndex].pictureData)
                
                currentLeadingNeighbor = innerTiles[innerTileIndex].id
                tileMustHaveId = innerTiles[innerTileIndex].trailingNeighbor!
                currentRow.append(innerTiles[innerTileIndex].id)
            }
            
            currentTopNeighborID = grid[i].last!
            
            /// finish row with another side tile
            let trailingSideTileIndex = sideTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedSides.contains($0.id) })!
            while sideTiles[trailingSideTileIndex].leadingNeighbor != currentLeadingNeighbor || sideTiles[trailingSideTileIndex].trailingNeighbor != nil || sideTiles[trailingSideTileIndex].topNeighbor != currentTopNeighborID {
                sideTiles[trailingSideTileIndex].rotateClockwise()
                counterRotations += 1
                if counterRotations > 3 {
                    /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                    sideTiles[trailingSideTileIndex].flipVertical()
                    counterRotations = 0
                }
            }
            counterRotations = 0
            completePicture.addArrayOnRightSide(startRow: startRowCompletePicture, array: sideTiles[trailingSideTileIndex].pictureData)
            
            currentTopNeighborID = currentRow.first!
            currentLeadingNeighbor = nil
            tileMustHaveId = sideTiles[sideTiles.firstIndex(where: {$0.id == currentTopNeighborID})!].bottomNeighbor!
            
            usedSides.append(sideTiles[trailingSideTileIndex].id)
            currentRow.append(sideTiles[trailingSideTileIndex].id)
            grid.append(currentRow)
            currentRow.removeAll()
        }
        
        /// finish grid with the bottom row
        
        startRowCompletePicture = completePicture.count
        /// therefor first add the bottom left corner
        let lbCornerIndex = cornerTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedCorners.contains($0.id) })!
        while cornerTiles[lbCornerIndex].topNeighbor != currentTopNeighborID || cornerTiles[lbCornerIndex].leadingNeighbor != nil || cornerTiles[lbCornerIndex].bottomNeighbor != nil {
            cornerTiles[lbCornerIndex].rotateClockwise()
            counterRotations += 1
            if counterRotations > 3 {
                /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                cornerTiles[lbCornerIndex].flipVertical()
                counterRotations = 0
            }
        }
        counterRotations = 0
        completePicture.append(contentsOf: cornerTiles[lbCornerIndex].pictureData)
        
        currentRow.append(cornerTiles[lbCornerIndex].id)
        
        tileMustHaveId = cornerTiles[lbCornerIndex].trailingNeighbor!
        currentLeadingNeighbor = cornerTiles[lbCornerIndex].id
        
        /// next step is to add as many side tiles as needed
        for _ in 0 ..< sideTiles.count / 4 {
            let indexTrailingNeighbour = sideTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedSides.contains($0.id)})!
            while sideTiles[indexTrailingNeighbour].bottomNeighbor != nil || sideTiles[indexTrailingNeighbour].leadingNeighbor != currentLeadingNeighbor {
                sideTiles[indexTrailingNeighbour].rotateClockwise()
                counterRotations += 1
                if counterRotations > 3 {
                    /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                    sideTiles[indexTrailingNeighbour].flipVertical()
                    counterRotations = 0
                }
            }
            counterRotations = 0
            completePicture.addArrayOnRightSide(startRow: startRowCompletePicture, array: sideTiles[indexTrailingNeighbour].pictureData)
            
            usedSides.append(sideTiles[indexTrailingNeighbour].id)
            currentLeadingNeighbor = sideTiles[indexTrailingNeighbour].id
            tileMustHaveId = sideTiles[indexTrailingNeighbour].trailingNeighbor!
            currentRow.append(sideTiles[indexTrailingNeighbour].id)
        }
        
        /// next step is to add the bottiom right corner
        let brCornerTileIndex = cornerTiles.firstIndex(where: { $0.id == tileMustHaveId && !usedCorners.contains($0.id) })!
        currentRow.append(cornerTiles[brCornerTileIndex].id)
        usedCorners.append(cornerTiles[brCornerTileIndex].id)
        while cornerTiles[brCornerTileIndex].leadingNeighbor != currentLeadingNeighbor || cornerTiles[brCornerTileIndex].bottomNeighbor != nil || cornerTiles[brCornerTileIndex].trailingNeighbor != nil {
            cornerTiles[brCornerTileIndex].rotateClockwise()
            counterRotations += 1
            if counterRotations > 3 {
                /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                cornerTiles[brCornerTileIndex].flipVertical()
                counterRotations = 0
            }
        }
        counterRotations = 0
        completePicture.addArrayOnRightSide(startRow: startRowCompletePicture, array: cornerTiles[brCornerTileIndex].pictureData)
        
        grid.append(currentRow)
        currentRow.removeAll()
        
        /// grid is now filled and image is merged
        
        var counterLoop = 0
        var mosterLocations = findMonster(in: completePicture)
        while mosterLocations.isEmpty {
            completePicture.rotateClockwise()
            counterRotations += 1
            if counterRotations > 3 {
                /// means there was a full cycle. Tile needs to be flipped and maybe then rotated again
                completePicture.flipHorizontal()
                counterRotations = 0
            }
            
            mosterLocations = findMonster(in: completePicture)
            counterLoop += 1
        }
        
        let monsterOccupiedFields = 15 * mosterLocations.count
        let availableFields = completePicture.reduce("", +).filter { $0 == "#" }.count
        print("Task2: There are \(mosterLocations.count) monsters in the sea. The water roughness is \(availableFields - monsterOccupiedFields)")
        
    }
}
