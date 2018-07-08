//Pat

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is CookBookIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return CookBookIntentHandler()
    }
}
