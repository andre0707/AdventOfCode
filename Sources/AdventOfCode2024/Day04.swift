import Foundation

struct Day4 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day04", ofType: "txt")!)
        let rows = input.dropLast(1).components(separatedBy: .newlines)
        
        let grid = rows.map { $0.map { $0 } }
        
        // MARK: - Task 1
        
        var counter = 0
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                switch grid[y][x] {
                case "X":
                    // right
                    if x + 3 < grid[y].count {
                        if grid[y][x+1..<x+4] == ["M", "A", "S"] {
                            counter += 1
                        }
                    }
                    // right bottom
                    if x + 3 < grid[y].count && y + 3 < grid.count {
                        if grid[y+1][x+1] == "M" && grid[y+2][x+2] == "A" && grid[y+3][x+3] == "S" {
                            counter += 1
                        }
                    }
                    // bottom
                    if y + 3 < grid.count {
                        if grid[y+1][x] == "M" && grid[y+2][x] == "A" && grid[y+3][x] == "S" {
                            counter += 1
                        }
                    }
                    // left bottom
                    if x - 3 >= 0 && y + 3 < grid.count {
                        if grid[y+1][x-1] == "M" && grid[y+2][x-2] == "A" && grid[y+3][x-3] == "S" {
                            counter += 1
                        }
                    }
                    // left
                    if x - 3 >= 0 {
                        if grid[y][x-3..<x] == ["S", "A", "M"] {
                            counter += 1
                        }
                    }
                    // left top
                    if x - 3 >= 0 && y - 3 >= 0 {
                        if grid[y-1][x-1] == "M" && grid[y-2][x-2] == "A" && grid[y-3][x-3] == "S" {
                            counter += 1
                        }
                    }
                    // top
                    if y - 3 >= 0 {
                        if grid[y-1][x] == "M" && grid[y-2][x] == "A" && grid[y-3][x] == "S" {
                            counter += 1
                        }
                    }
                    // right top
                    if x + 3 < grid[y].count && y - 3 >= 0 {
                        if grid[y-1][x+1] == "M" && grid[y-2][x+2] == "A" && grid[y-3][x+3] == "S" {
                            counter += 1
                        }
                    }
                    
                default:
                    continue
                }
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print(counter) // 2639
        
        
        // MARK: - Task 2
        
        var counter2 = 0
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                switch grid[y][x] {
                case "A":
                    guard y > 0 && y < grid.count - 1 else { continue }
                    guard x > 0 && x < grid[y].count - 1 else { continue }
                    // left top to right bottom
                    guard (grid[y-1][x-1] == "M" && grid[y+1][x+1] == "S") || (grid[y-1][x-1] == "S" && grid[y+1][x+1] == "M") else { continue }
                    // left bottom to right top
                    guard (grid[y+1][x-1] == "M" && grid[y-1][x+1] == "S") || (grid[y+1][x-1] == "S" && grid[y-1][x+1] == "M") else { continue }
                    
                    counter2 += 1
                    
                default:
                    continue
                }
            }
        }
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print(counter2) // 2005
    }
}
