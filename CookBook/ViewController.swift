//Pat

import UIKit
import IntentsUI

class ViewController: UIViewController {
    let nameKey = "recipeNameKey"

    @IBOutlet weak var addEditSiriShortcut: UIButton!
    private var shortcutManager: VoiceShortcutManager?
    private var dataManager: CookBookDataManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        shortcutManager = VoiceShortcutManager()
        dataManager = CookBookDataManagerImpl()
        updateVoiceShortcuts()
    }

    @IBAction func addEditSiriShortcutDidTap(_ sender: Any) {
        presentVoiceShortcutViewController()
    }

    private func updateTitleForEdit() {
        addEditSiriShortcut.setTitle("Edit Pad Thai shortcut", for: .normal)
    }

    private func updateTitleForAdd() {
        addEditSiriShortcut.setTitle("Add Pad Thai shortcut", for: .normal)
    }

    private func presentVoiceShortcutViewController() {
        guard let shortcutManager = shortcutManager,
            let recipe = dataManager?.getRecipe("padthai") else {return}
        let cookBookIntent =  CookBookIntent()

        cookBookIntent.recipe = INObject(identifier: recipe.identifier, display: recipe.name)
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

    fileprivate func updateVoiceShortcuts() {
        shortcutManager?.updateShortcut{ [weak self] in
            self?.updateAddEditButton()
        }
    }

    private func updateAddEditButton() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if let voiceShortcuts = strongSelf.shortcutManager?.voiceShortcuts,
                voiceShortcuts.first != nil {
                strongSelf.updateTitleForEdit()
            } else {
                strongSelf.updateTitleForAdd()
            }
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
