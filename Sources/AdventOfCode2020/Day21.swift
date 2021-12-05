import Foundation


struct Day21 {
    static func run() {
        let input = try! String(contentsOfFile: Bundle.module.path(forResource: "Resources/input_Day21", ofType: "txt")!).components(separatedBy: .newlines)
        
        
        var allIncredients = [String]() // needs to be an array and not a set, because incredients can occour in different foods and we need the total number over all foods
        //var incredientAllergenOptions = [String: Set<String>]()  //does not work. Must look at it the other way around
        var allergeneIngredientOptions = [String: Set<String>]()
        
        for food in input {
            if food.isEmpty { continue }
            
            let components = food.components(separatedBy: " (contains ")
            let foodIngredients = components[0].components(separatedBy: .whitespaces)
            let foodAllergens = components[1].dropLast().components(separatedBy: ", ")
            
            allIncredients.append(contentsOf: foodIngredients)
            
            for foodAllergen in foodAllergens {
                if let ingredientOption = allergeneIngredientOptions[foodAllergen] {
                    allergeneIngredientOptions[foodAllergen] = ingredientOption.intersection(foodIngredients)
                } else {
                    allergeneIngredientOptions[foodAllergen] = Set(foodIngredients)
                }
            }
        }
        
        // MARK: - Task1
        
        var saveIngredientsToEat = allIncredients // start with all possible incredients
        // then remove all the ones which are not save to eat
        allergeneIngredientOptions.forEach { allergeneIngredientOption in
            allergeneIngredientOption.value.forEach { ingredient in
                saveIngredientsToEat.removeAll(where: { $0 == ingredient })
            }
        }
        
        print("Task1: There are \(saveIngredientsToEat.count) ingredients which can not contain any of the allergens") //1930
        
        
        // MARK: - Task2
        
        var allergeneList = allergeneIngredientOptions
        while true {
            let identifiedAllergenes = allergeneList.filter { $0.value.count == 1 }
            if identifiedAllergenes.count == allergeneList.count { break }
            
            for identifiedAllergene in identifiedAllergenes {
                for allergene in allergeneList {
                    if allergene.key == identifiedAllergene.key { continue }
                    allergeneList[allergene.key]?.subtract(identifiedAllergene.value)
                }
            }
        }
        
        
        let alphabeticallyIngredientList = allergeneList.map { (allergene: $0.key, ingredient: $0.value.first!) }.sorted { $0.allergene < $1.allergene }.map { $0.ingredient }
        
        
        print("Task2: My canonical dangerous ingredient list: \(alphabeticallyIngredientList.joined(separator: ","))") //spcqmzfg,rpf,dzqlq,pflk,bltrbvz,xbdh,spql,bltzkxx
    }
}
