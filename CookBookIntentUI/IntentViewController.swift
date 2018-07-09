//Pat

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {

    private let margin = CGFloat(8)
    var dataManager: CookBookDataManager?
    @IBOutlet weak var contentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = CookBookDataManagerImpl()
    }

    // MARK: - INUIHostedViewControlling

    func configureView(for parameters: Set<INParameter>,
                       of interaction: INInteraction,
                       interactiveBehavior: INUIInteractiveBehavior,
                       context: INUIHostedViewContext,
                       completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard let intent = interaction.intent as? CookBookIntent,
            let identifier = intent.recipe?.identifier,
            let recipe = dataManager?.getRecipe(identifier) else {
                completion(false, Set(), .zero)
                return
        }
        clearStackView()
        let size = createInstructionList(with: recipe)
        completion(true, parameters, size)
        contentStackView.setNeedsLayout()
    }

    private func createInstructionList(with recipe: Recipe) -> CGSize {
        var requireHeight = CGFloat(0)
        recipe.instruction.enumerated().forEach { (index, text) in
            let label = createLabel(with: displayText(index, text))
            requireHeight += height(with: label)
            contentStackView.addArrangedSubview(label)
        }
        requireHeight += CGFloat(recipe.instruction.count - 1) * margin
        return CGSize(width: view.frame.width, height: requireHeight)
    }

    private func clearStackView() {
        contentStackView.arrangedSubviews.forEach{
            $0.removeFromSuperview()
        }
    }

    private lazy var defaultSize: CGSize = {
        return CGSize(
        width: view.frame.width - margin*2,
        height: CGFloat.greatestFiniteMagnitude
        )
    }()

    private func displayText(_ index: Int, _ text: String) -> String {
        return "\(index+1)) \(text)"
    }

    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }

    private func height(with label: UILabel) -> CGFloat {
        guard let text = label.text,
            let font = label.font else { return 0 }
        return (text as NSString).boundingRect(with: defaultSize,
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: [.font : font],
                                               context: nil).height
    }
}
