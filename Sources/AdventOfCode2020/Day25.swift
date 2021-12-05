import Foundation


struct Day25 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day25", ofType: "txt")!).components(separatedBy: .newlines)
        
        let publicKeys = (card: Int(input[0])!, door: Int(input[1]))
            
        var loopSizeOfCard = 0
        var loopSizeOfDoor = 0
        let subjectNumber = 7
        var calculatedPublicKeyOfCard = 1
        var calculatedPublicKeyOfDoor = 1
        
        while true {
            if calculatedPublicKeyOfCard == publicKeys.card && calculatedPublicKeyOfDoor == publicKeys.door { break }
            
            if calculatedPublicKeyOfCard != publicKeys.card {
                calculatedPublicKeyOfCard = (calculatedPublicKeyOfCard * subjectNumber) % 20201227
                loopSizeOfCard += 1
            }
            
            if calculatedPublicKeyOfDoor != publicKeys.door {
                calculatedPublicKeyOfDoor = (calculatedPublicKeyOfDoor * subjectNumber) % 20201227
                loopSizeOfDoor += 1
            }
        }
        
        var encryptionKeyCardProduces = 1
        for _ in 0 ..< loopSizeOfCard {
            encryptionKeyCardProduces = (encryptionKeyCardProduces * calculatedPublicKeyOfDoor) % 20201227
        }
        
        var encryptionKeyDoorProduces = 1
        for _ in 0 ..< loopSizeOfDoor {
            encryptionKeyDoorProduces = (encryptionKeyDoorProduces * calculatedPublicKeyOfCard) % 20201227
        }
        
        if encryptionKeyCardProduces != encryptionKeyDoorProduces {
            assertionFailure("the two encryption keys are not equal")
        }
        
        // MARK: - Task1
        
        print("Task1: The encrption key is: \(encryptionKeyCardProduces)") //15467093
    }
}
