//Pat

import Foundation
final class CookBookIntentHandler: NSObject, CookBookIntentHandling {

    func handle(intent: CookBookIntent, completion: @escaping (CookBookIntentResponse) -> Void) {
        guard let recipe = intent.recipe else {
            completion(CookBookIntentResponse(code: .failure, userActivity: nil))
            return
        }
        completion(CookBookIntentResponse.success(recipe: recipe))
    }
}
