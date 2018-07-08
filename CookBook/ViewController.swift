//Pat

import UIKit
import IntentsUI

class ViewController: UIViewController {
    let nameKey = "recipeNameKey"

    @IBOutlet weak var addEditSiriShortcut: UIButton!
    private var shortcutManager: VoiceShortcutManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        shortcutManager = VoiceShortcutManager()
        updateVoiceShortcuts()
    }

    @IBAction func addSiriShortcutDidTap(_ sender: Any) {
        guard let shortcutManager = shortcutManager else {return}
        let cookBookIntent =  CookBookIntent()
        cookBookIntent.recipe = INObject(identifier: "padthai", display: "Pad Thai")
        guard let shortcut = INShortcut(intent:cookBookIntent) else {return}
        if let voiceShortcuts = shortcutManager.voiceShortcuts,
            let shortcut = voiceShortcuts.first {
            let editSiriShortcutVC = INUIEditVoiceShortcutViewController(voiceShortcut: shortcut)
            editSiriShortcutVC.delegate = self
            present(editSiriShortcutVC, animated: true, completion: nil)
        } else {
            let addSiriShortcutVC = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            addSiriShortcutVC.delegate = self
            present(addSiriShortcutVC, animated: true, completion: nil)
        }
    }

    private func updateAddEditButton() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if let voiceShortcuts = strongSelf.shortcutManager?.voiceShortcuts,
                voiceShortcuts.first != nil {
                strongSelf.addEditSiriShortcut.setTitle("Edit Pad Thai shortcut", for: .normal)
            } else {
                strongSelf.addEditSiriShortcut.setTitle("Add Pad Thai shortcut", for: .normal)
            }
        }
    }

    fileprivate func updateVoiceShortcuts() {
        shortcutManager?.updateShortcut{ [weak self] in
            self?.updateAddEditButton()
        }
    }
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        if let error = error as NSError? {
            print(error)
            return
        }
        updateVoiceShortcuts()
        dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?,
                                         error: Error?) {
        if let error = error as NSError? {
            print(error)
            return
        }
        updateVoiceShortcuts()
        dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        updateVoiceShortcuts()
        dismiss(animated: true, completion: nil)
    }

    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
}
