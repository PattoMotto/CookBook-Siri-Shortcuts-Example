//Pat

struct Recipe: Codable {
    let identifier: String
    let name: String
    let instruction: [String]
}

protocol CookBookDataManager {
    func getRecipe(_ identifier: String) -> Recipe?
}

final class CookBookDataManagerImpl: CookBookDataManager {

    private lazy var recipes: [Recipe] = {
        return [
            Recipe(
                identifier: "padthai",
                name: "Pad Thai",
                instruction: ["Soak rice noodles in cold water 30 to 50 minutes, or until soft. Drain, and set aside.", "Heat butter in a wok or large heavy skillet. Saute chicken until browned. Remove, and set aside. Heat oil in wok over medium-high heat. Crack eggs into hot oil, and cook until firm. Stir in chicken, and cook for 5 minutes. Add softened noodles, and vinegar, fish sauce, sugar and red pepper. Adjust seasonings to taste. Mix while cooking, until noodles are tender. Add bean sprouts, and mix for 3 minutes."]
            ),
            Recipe(
                identifier: "yakisobachicken",
                name: "Yakisoba Chicken",
                instruction: ["In a large skillet combine sesame oil, canola oil and chili paste; stir-fry 30 seconds. Add garlic and stir fry an additional 30 seconds. Add chicken and 1/4 cup of the soy sauce and stir fry until chicken is no longer pink, about 5 minutes. Remove mixture from pan, set aside, and keep warm.", "In the emptied pan combine the onion, cabbage, and carrots. Stir-fry until cabbage begins to wilt, 2 to 3 minutes. Stir in the remaining soy sauce, cooked noodles, and the chicken mixture to pan and mix to blend. Serve and enjoy!"]
            )
        ]
    }()

    func getRecipe(_ identifier: String) -> Recipe? {
        return recipes.filter{ $0.identifier == identifier }.first
    }
}
