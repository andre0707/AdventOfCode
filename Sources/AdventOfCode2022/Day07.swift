import Foundation

struct Day7 {
    
    final class FilesystemEntry {
        let isDirectory: Bool
        
        let name: String
        
        private let _size: Int
        
        var size: Int {
            if isDirectory {
                return children.reduce(into: 0, { $0 += $1.size })
            } else {
                return _size
            }
        }
        
        var children: [FilesystemEntry]
        
        let parent: FilesystemEntry?
        
        
        init(name: String, size: Int, parent: FilesystemEntry?) {
            self.isDirectory = false
            self.name = name
            self._size = size
            self.children = []
            self.parent = parent
        }
        
        init(name: String, parent: FilesystemEntry?) {
            self.isDirectory = true
            self.name = name
            self._size = 0
            self.children = []
            self.parent = parent
        }
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
        var inputRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let firstRow = inputRows.removeFirst()
        guard firstRow == "$ cd /" else {
            assertionFailure("Not the right first line")
            return
        }
        
        
        let baseEntry: FilesystemEntry = FilesystemEntry(name: "/", parent: nil)
        var currentEntry = baseEntry
       
        for line in inputRows {
            let lineComponents = line.components(separatedBy: .whitespaces)
            
            if line.prefix(1) == "$" {
                /// We have a command
                switch lineComponents[1] {
                case "cd":
                    switch lineComponents[2] {
                    case "/":
                        currentEntry = baseEntry
                        
                    case "..":
                        currentEntry = currentEntry.parent!
                        
                    default:
                        currentEntry = currentEntry.children.first(where: { $0.name == lineComponents[2] })!
                        
                    }
                    
                case "ls":
                    break
                    
                default:
                    assertionFailure("unknown command")
                    return
                }
                
                
            } else {
                /// We have a line with content of a directory
                
                switch lineComponents[0] {
                case "dir":
                    currentEntry.children.append(FilesystemEntry(name: lineComponents[1], parent: currentEntry))
                    
                default:
                    currentEntry.children.append(FilesystemEntry(name: lineComponents[1], size: Int(lineComponents[0])!, parent: currentEntry))
                    
                }
            }
        }
        
        
        // MARK: - Task 1
        
        var totalSize = 0
        
        @discardableResult
        func size(entry: FilesystemEntry) -> Int {
            
            var entrySize = 0
            
            for child in entry.children {
                
                if child.isDirectory {
                    entrySize += size(entry: child)
                } else {
                    entrySize += child.size
                }
                
            }
            
            if entry.isDirectory && entrySize < 100_000 {
                totalSize += entrySize
            }
            
            return entrySize
        }
        
        size(entry: baseEntry)
        
        print("--------------------------------------------------------------")
        print("Puzzle 1:\n")
        print("The sum is: \(totalSize)")
        
        
        // MARK: - Task 2
        
        var allDirectoris: [FilesystemEntry] = []
        
        func findAllDirectories(startingFrom entry: FilesystemEntry) {
            for child in entry.children {
                if child.isDirectory {
                    findAllDirectories(startingFrom: child)
                } else {
                    continue
                }
                allDirectoris.append(child)
            }
        }
        
        findAllDirectories(startingFrom: baseEntry)
        
        let totalDiskSpaceAvailable = 70000000
        let neededFreeSpace = 30000000
        let usedSpace = baseEntry.size
        let cleanUpSpace = neededFreeSpace - (totalDiskSpaceAvailable - usedSpace)
        
        let directorySizes = allDirectoris
            .map { $0.size }
            .filter { $0 >= cleanUpSpace }
            .sorted(by: <)
            
        
        print("--------------------------------------------------------------")
        print("Puzzle 2:\n")
        print("Size of directory which needs to be deleted: \(directorySizes.first!)")
    }
}
