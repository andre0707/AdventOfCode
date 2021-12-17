import Foundation

struct Day17 {
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day17", ofType: "txt")!)
            .replacingOccurrences(of: "\n", with: "")
        
        let components = input.components(separatedBy: .whitespaces)
        let xRange = components[2].replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "x=", with: "").components(separatedBy: "..")
        let yRange = components[3].replacingOccurrences(of: "y=", with: "").components(separatedBy: "..")
        
        let minX = Int(xRange[0])!
        let maxX = Int(xRange[1])!
        let minY = Int(yRange[0])!
        let maxY = Int(yRange[1])!
        
        
        var velocityForMaxReadchedY: (x: Int, y: Int)? = nil
        var maxReachedY: Int? = nil
        var currentReachedY = 0
        
        var counterValidInitialVelocities = 0
        
        var probePosition = (x: 0, y: 0)
        var velocity = (x: 0, y: 0)
        
        func shoot(canSkipHitsWithLowerMaximumY: Bool) {
            for x in 1 ... maxX {
                for y in minY ... abs(minY) {
                    velocity.x = x
                    velocity.y = y
                    probePosition = (x: 0, y: 0)
                    currentReachedY = 0
                    
                    while true {
                        /// Apply velocity
                        probePosition.x += velocity.x
                        probePosition.y += velocity.y
                        
                        /// Check if this try even hits a larger y position
                        if probePosition.y > currentReachedY {
                            currentReachedY = probePosition.y
                        } else {
                            if canSkipHitsWithLowerMaximumY && maxReachedY != nil && currentReachedY < maxReachedY! {
                                break
                            }
                        }
                        
                        /// Check for some out of bounds conditions
                        if probePosition.x > maxX || probePosition.y < minY { break }
                        if probePosition.x < minX && velocity.x == 0 { break }
                        
                        /// Check for target hit area
                        if (minX ... maxX).contains(probePosition.x) && (minY ... maxY).contains(probePosition.y) {
                            if maxReachedY == nil {
                                maxReachedY = currentReachedY
                            } else {
                                if currentReachedY > maxReachedY! {
                                    maxReachedY = currentReachedY
                                }
                            }
                            velocityForMaxReadchedY = (x: x, y: y)
                            if !canSkipHitsWithLowerMaximumY {
                                counterValidInitialVelocities += 1
                            }
                            break
                        }
                        
                        /// Adjust veleocity
                        if velocity.x != 0 {
                            velocity.x += velocity.x < 0 ? 1 : -1
                        }
                        velocity.y -= 1
                    }
                }
            }
        }
        
        
        // MARK: - Task 1
        
        shoot(canSkipHitsWithLowerMaximumY: true)
        if let velocityForMaxReadchedY = velocityForMaxReadchedY {
            print("Velocity with maxY at \(maxReachedY!) is: (x: \(velocityForMaxReadchedY.x), y: \(velocityForMaxReadchedY.y))")
        } else {
            print("Could not find a matching velocity")
        }
        
        
        // MARK: - Task 2
        
        shoot(canSkipHitsWithLowerMaximumY: false)
        print("There are \(counterValidInitialVelocities) initial velocities which will hit the target")
    }
}
