//Pat

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {

    private let margin = CGFloat(8)

    @IBOutlet weak var contentStackView: UIStackView!

    var dataManager: CookBookDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = CookBookDataManagerImpl()
    }

    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
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
        contentStackView.arrangedSubviews.forEach{
            $0.removeFromSuperview()
        }

        var requireHeight = CGFloat(0)
        let defaultSize = CGSize(
            width: view.frame.width - margin*2,
            height: CGFloat.greatestFiniteMagnitude
        )

        recipe.instruction.enumerated().forEach { (index, text) in
            let displayText = "\(index+1)) \(text)"
            let label = UILabel()
            label.text = displayText
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            requireHeight += (displayText as NSString).boundingRect(with: defaultSize,
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [.font : label.font],
                                                                    context: nil).height
            contentStackView.addArrangedSubview(label)
        }
        requireHeight += CGFloat(recipe.instruction.count - 1) * margin
        completion(true, parameters, CGSize(width: view.frame.width, height: requireHeight))
        contentStackView.setNeedsLayout()
    }
}
