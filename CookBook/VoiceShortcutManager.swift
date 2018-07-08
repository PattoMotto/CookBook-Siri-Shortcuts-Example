//Pat

import Foundation
import Intents

final class VoiceShortcutManager {
    var voiceShortcuts: [INVoiceShortcut]?

    init() {
        updateShortcut()
    }

    public func updateShortcut(_ completion: (() -> Void)? = nil) {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts {[weak self] (voiceShortcutsFromCenter, error) in
            guard let voiceShortcuts = voiceShortcutsFromCenter else {
                if let error = error as NSError? {
                    print(error)
                }
                return
            }
            self?.voiceShortcuts = voiceShortcuts
            completion?()
        }
    }
}
