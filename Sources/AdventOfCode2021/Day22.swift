import Foundation

struct Day22 {
    
    struct CubePosition: Hashable {
        let x: Int
        let y: Int
        let z: Int
        
        func hasElement(smaller value: Int) -> Bool {
            x < value || y < value || z < value
        }
        
        func hasElement(bigger value: Int) -> Bool {
            x > value || y > value || z > value
        }
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_DayTest", ofType: "txt")!)
            .components(separatedBy: .newlines)
        
        
        // way too slow..
        
        var cubes: [CubePosition : Bool] = [:]
        input.forEach { line in
            guard !line.isEmpty else { return }
            
            let parts = line.components(separatedBy: " ")
            let turnOn = parts[0] == "on"
            
            let coordinateRanges = parts[1].components(separatedBy: ",")
            
            let xRangeComponents = coordinateRanges[0].replacingOccurrences(of: "x=", with: "").components(separatedBy: "..")
            let yRangeComponents = coordinateRanges[1].replacingOccurrences(of: "y=", with: "").components(separatedBy: "..")
            let zRangeComponents = coordinateRanges[2].replacingOccurrences(of: "z=", with: "").components(separatedBy: "..")
            
            for xRange in Int(xRangeComponents[0])!...Int(xRangeComponents[1])! {
                for yRange in Int(yRangeComponents[0])!...Int(yRangeComponents[1])! {
                    for zRange in Int(zRangeComponents[0])!...Int(zRangeComponents[1])! {
                        cubes[CubePosition(x: xRange, y: yRange, z: zRange)] = turnOn
                    }
                }
            }
        }

        
        let switchedOnCubes = cubes.filter {
            guard !$0.key.hasElement(smaller: -50) else { return false }
            guard !$0.key.hasElement(bigger: 50) else { return false }
            
            return $0.value
        }
            .count
        
        print("There are \(switchedOnCubes) switched on cubes.")
    }
}
