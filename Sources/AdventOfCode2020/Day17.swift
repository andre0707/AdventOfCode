import Foundation


struct Day17 {
    
    class CubeGrid {
        private var is3Dgrid = true
        private var grid: [[[[Bool]]]] = []
        
        init?(with twoDgrid: [String], dimension: Int) {
            if !(3 ... 4).contains(dimension) { return nil }
            self.is3Dgrid = dimension == 3
            
            var gridSlice: [[Bool]] = []
            for line in twoDgrid {
                var filledLine: [Bool] = []
                for char in line {
                    filledLine.append(char == "#")
                }
                gridSlice.append(filledLine)
            }
            self.grid.append([gridSlice])
            
            self.increaseGrid()
        }
        
        func isCubeActive(x: Int, y: Int, z: Int, w: Int) -> Bool {
            if x < 0 || y < 0 || z < 0 || w < 0 { return false }
            
            if w >= self.grid.count { return false }
            if z >= self.grid[w].count { return false }
            if y >= self.grid[w][z].count { return false }
            if x >= self.grid[w][z][y].count { return false }
            
            return self.grid[w][z][y][x]
        }
        
        func countActiveNeihgborsForCube(x: Int, y: Int, z: Int, w: Int) -> Int {
            var count = 0
            for ww in w - 1 ... w + 1 {
                for zz in z - 1 ... z + 1 {
                    for yy in y - 1 ... y + 1 {
                        for xx in x - 1 ... x + 1 {
                            if xx == x && yy == y && zz == z && ww == w { continue }
                            count += self.isCubeActive(x: xx, y: yy, z: zz, w: ww) ? 1 : 0
                        }
                    }
                }
            }
            
            return count
        }
        
        var activeCubesInGrid: Int { return self.grid.reduce(into: 0, { $0 += $1.reduce(into: 0, { $0 += $1.reduce(into: 0, { $0 += $1.reduce(into: 0, { $0 += $1 ? 1 : 0 }) }) }) }) }
        
        func increaseGrid() {
            let sizeInWDimension = self.is3Dgrid ? 1 : self.grid.count
            for w in 0 ..< sizeInWDimension {
                for z in 0 ..< self.grid[w].count {
                    for y in 0 ..< self.grid[w][z].count {
                        self.grid[w][z][y].insert(false, at: 0)
                        self.grid[w][z][y].append(false)
                    }
                    self.grid[w][z].insert(Array.init(repeating: false, count: self.grid[w][z][0].count), at: 0)
                    self.grid[w][z].append(Array.init(repeating: false, count: self.grid[w][z][0].count))
                }
                let slice = Array.init(repeating: Array.init(repeating: false, count: self.grid[w][0][0].count), count: self.grid[w][0].count)
                self.grid[w].insert(slice, at: 0)
                self.grid[w].append(slice)
            }
            if self.is3Dgrid { return }
            let grid = Array.init(repeating: Array.init(repeating: Array.init(repeating: false, count: self.grid[0][0][0].count), count: self.grid[0][0].count), count: self.grid[0].count)
            self.grid.insert(grid, at: 0)
            self.grid.append(grid)
        }
        
        func runBootCycle() {
            var workingGrid = self.grid
            for w in 0 ..< workingGrid.count {
                for z in 0 ..< workingGrid[w].count {
                    for y in 0 ..< workingGrid[w][z].count {
                        for x in 0 ..< workingGrid[w][z][y].count {
                            if self.isCubeActive(x: x, y: y, z: z, w: w) {
                                if !(2 ... 3).contains(self.countActiveNeihgborsForCube(x: x, y: y, z: z, w: w)) {
                                    workingGrid[w][z][y][x].toggle()
                                }
                            } else {
                                if self.countActiveNeihgborsForCube(x: x, y: y, z: z, w: w) == 3 {
                                    workingGrid[w][z][y][x].toggle()
                                }
                            }
                        }
                    }
                }
            }
            self.grid = workingGrid
            self.increaseGrid()
        }
        
        func printCubeSlice(z: Int, w: Int) {
            if z < 0 || z >= self.grid[w].count { return }
            print("\nz=\(z), w=\(w)")
            for y in 0 ..< self.grid[w][z].count {
                print(self.grid[w][z][y].reduce(into: "", { $0 += ($1 ? "#" : ".") }))
            }
        }
        
        func printCubeSliceForActiveNeighbors(z: Int, w: Int) {
            if z < 0 || z >= self.grid[w].count { return }
            print("\nz=\(z), w=\(w)")
            for y in 0 ..< self.grid[w][z].count {
                var line = ""
                for x in 0 ..< self.grid[w][z][y].count {
                    if (!line.isEmpty) { line += "," }
                    line += "\(self.countActiveNeihgborsForCube(x: x, y: y, z: z, w: w))"
                }
                print(line)
            }
        }
        
        func printGrid() {
            for w in 0 ..< self.grid.count {
                for z in 0 ..< self.grid[w].count {
                    self.printCubeSlice(z: z, w: w)
                }
            }
        }
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day17", ofType: "txt")!).components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        
        // MARK: - Task1
        guard let cubeGrid3D = CubeGrid(with: input, dimension: 3) else { fatalError("wrong input format") }
        
        for _ in 0 ..< 6 {
            cubeGrid3D.runBootCycle()
        }
        print("Task1: There are \(cubeGrid3D.activeCubesInGrid) active cubes in the 3D grid.") //395
        
        
        
        // MARK: - Task2
        guard let cubeGrid4D = CubeGrid(with: input, dimension: 4) else { fatalError("wrong input format") }
        
        for _ in 0 ..< 6 {
            cubeGrid4D.runBootCycle()
        }
        print("Task2: There are \(cubeGrid4D.activeCubesInGrid) active cubes in the 4D grid.") //2296
    }
}
