import Foundation

struct Day2 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day02", ofType: "txt")!)
        let directions = input.components(separatedBy: .newlines).compactMap { direction -> (String, Int)? in
            let components = direction.components(separatedBy: .whitespaces)
            guard components.count > 1,
                  let value = Int(components[1])
            else { return nil }
            return (components[0], value)
        }
        guard directions.count > 0 else { return }
        
        
        // MARK: - Task 1
        
        var horizontalPosition = 0
        var depth = 0
        
        for direction in directions {
            switch direction.0 {
            case "forward":
                horizontalPosition += direction.1
            case "down":
                depth += direction.1
            case "up":
                depth -= direction.1
            default:
                continue
            }
        }
        
        print("Result of horizontal (\(horizontalPosition)) * depth (\(depth)) = \(horizontalPosition * depth)")
        
        
        // MARK: - Task 2
        
        horizontalPosition = 0
        depth = 0
        var aim = 0
        
        for direction in directions {
            switch direction.0 {
            case "forward":
                horizontalPosition += direction.1
                depth += aim * direction.1
            case "down":
                aim += direction.1
            case "up":
                aim -= direction.1
            default:
                continue
            }
        }
        
        print("Result of horizontal (\(horizontalPosition)) * depth (\(depth)) = \(horizontalPosition * depth)")
    }
}
