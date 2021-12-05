import Foundation


struct Passport {
    var byr: Int
    var iyr: Int
    var eyr: Int
    var hgt: Measurement<UnitLength>
    var hcl: String
    var ecl: String
    var pid: String
    
    init(from passportString: String) {
        
        self.byr = 0
        self.iyr = 0
        self.eyr = 0
        self.hgt = Measurement(value: 0, unit: UnitLength.centimeters)
        self.hcl = ""
        self.ecl = ""
        self.pid = ""
        
        let components = passportString.components(separatedBy: .whitespacesAndNewlines)
        components.forEach { pair in
            let pairComponents = pair.components(separatedBy: ":")
            
            switch pairComponents.first {
                case "byr":
                    self.byr = Int(pairComponents.last!)!
                case "iyr":
                    self.iyr  = Int(pairComponents.last!)!
                case "eyr":
                    self.eyr  = Int(pairComponents.last!)!
                case "hgt":
                    let value = Double(pairComponents.last!.filter { $0.isNumber })!
                    let unit: UnitLength = pairComponents.last!.filter { $0.isLetter } == "cm" ? .centimeters : .inches
                    self.hgt = Measurement(value: value, unit: unit)
                case "hcl":
                    self.hcl = pairComponents.last!
                case "ecl":
                    self.ecl = pairComponents.last!
                case "pid":
                    self.pid = pairComponents.last!
                default:
                    break
            }
        }
    }
    
    var isValid: Bool {
        if !(1920 ... 2002).contains(self.byr) { return false }
        if !(2010 ... 2020).contains(self.iyr) { return false }
        if !(2020 ... 2030).contains(self.eyr) { return false }
        
        switch self.hgt.unit {
            case .centimeters:
                if !(150 ... 193).contains(self.hgt.value) { return false }
            case .inches:
                if !(59 ... 76).contains(self.hgt.value) { return false }
            default:
                return false
        }
        
        if self.hcl.first != "#" { return false}
        if self.hcl.count != 7 { return false}
        if self.hcl.dropFirst().range(of: "^[a-z0-9]+$", options: .regularExpression) == nil { return false}
        
        if !["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(self.ecl) { return false }
        
        if self.pid.count != 9 || !self.pid.allSatisfy({ $0.isNumber })  { return false}
        
        return true
    }
}


struct Day4 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day04", ofType: "txt")!)
       
        let passports = input.components(separatedBy: "\n\n")
        
        let requiredFields = [
            "byr",
            "iyr",
            "eyr",
            "hgt",
            "hcl",
            "ecl",
            "pid"
        ]
        
        let validPassports = passports.filter { passport in
            requiredFields.allSatisfy { passport.contains($0) }
        }
        print("There are \(validPassports.count) valid passports for part 1")
        
        
        let validatedPassports = validPassports.filter { Passport(from: $0).isValid }
        print("There are \(validatedPassports.count) validated passports for part 2")
    }
}
