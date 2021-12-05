import Foundation


struct Day12 {
    
    enum Action {
        case N(Int)
        case S(Int)
        case E(Int)
        case W(Int)
        case L(Int)
        case R(Int)
        case F(Int)
        
        init?(string: String) {
            if string.isEmpty { return nil }
            
            let value = Int(string.dropFirst())!
            switch string.first! {
                case "N":
                    self = .N(value)
                case "S":
                    self = .S(-value)
                case "E":
                    self = .E(value)
                case "W":
                    self = .W(-value)
                case "L":
                    self = .L(value)
                case "R":
                    self = .R(value)
                case "F":
                    self = .F(value)
                default:
                    return nil
            }
        }
        
        mutating func turn(action: Action) {
            switch action {
                case .R(let value):
                    switch value {
                        case 90:
                            switch self {
                                case .N(let value):
                                    self = .E(value)
                                case .E(let value):
                                    self = .S(value)
                                case .S(let value):
                                    self = .W(value)
                                case .W(let value):
                                    self = .N(value)
                                default:
                                    return
                            }
                        case 180:
                            switch self {
                                case .N(let value):
                                    self = .S(value)
                                case .E(let value):
                                    self = .W(value)
                                case .S(let value):
                                    self = .N(value)
                                case .W(let value):
                                    self = .E(value)
                                default:
                                    return
                            }
                        case 270:
                            switch self {
                                case .N(let value):
                                    self = .W(value)
                                case .E(let value):
                                    self = .N(value)
                                case .S(let value):
                                    self = .E(value)
                                case .W(let value):
                                    self = .S(value)
                                default:
                                    return
                            }
                        default:
                            return
                    }
                case .L(let value):
                    switch value {
                        case 90:
                            self.turn(action: .R(270))
                        case 180:
                            self.turn(action: .R(180))
                        case 270:
                            self.turn(action: .R(90))
                        default:
                            return
                    }
                default:
                    return
            }
        }
        
        
    }
    
    
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day12", ofType: "txt")!).components(separatedBy: .newlines)
        
        let actions = input.compactMap { Action(string: $0) }
    
        
        var location = (lat: 0, lon: 0)
        var facing = Action.E(0)
        for action in actions {
            switch action {
                case .N(let value), .S(let value):
                    location.lat += value
                case .E(let value), .W(let value):
                    location.lon += value
                case .L, .R:
                    facing.turn(action: action)
                case .F(let value):
                    switch facing {
                        case .N:
                            location.lat += value
                        case .S:
                            location.lat -= value
                        case .E:
                            location.lon += value
                        case .W:
                            location.lon -= value
                        default:
                            break
                    }
            }
        }
        
        print("Task1: Position is \(location.lat >= 0 ? "N": "S") \(abs(location.lat)), \(location.lon >= 0 ? "E": "W") \(abs(location.lon)). Manhatten distance: \(abs(location.lat) + abs(location.lon))")
        
        
        var ship = (lat: 0, lon: 0)
        var waypoint = (lat: 1, lon: 10)
        for action in actions {
            switch action {
                case .N(let value), .S(let value):
                    waypoint.lat += value
                case .E(let value), .W(let value):
                    waypoint.lon += value
                case .L(let value):
                    switch value {
                        case 90:
                            swap(&waypoint.lat, &waypoint.lon)
                            waypoint.lon *= -1
                        case 180:
                            waypoint.lat *= -1
                            waypoint.lon *= -1
                        case 270:
                            swap(&waypoint.lat, &waypoint.lon)
                            waypoint.lat *= -1
                        default:
                            break
                    }
                case .R(let value):
                    switch value {
                        case 90:
                            swap(&waypoint.lat, &waypoint.lon)
                            waypoint.lat *= -1
                        case 180:
                            waypoint.lat *= -1
                            waypoint.lon *= -1
                        case 270:
                            swap(&waypoint.lat, &waypoint.lon)
                            waypoint.lon *= -1
                        default:
                            break
                    }
                case .F(let value):
                    ship.lat += value * waypoint.lat
                    ship.lon += value * waypoint.lon
            }
        }
        
        print("Task2: Ship position is \(ship.lat >= 0 ? "N": "S") \(abs(ship.lat)), \(ship.lon >= 0 ? "E": "W") \(abs(ship.lon)). Manhatten distance: \(abs(ship.lat) + abs(ship.lon))")
    }
}
