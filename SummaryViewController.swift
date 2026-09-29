// View Controller for the summary screen
import UIKit

class SummaryViewController: UIViewController {
    var bowlingGameController: BowlingGameController?
    var summaryLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        summaryLabel.text = "Summary"
        summaryLabel.frame = CGRect(x: 20, y: 50, width: view.bounds.width - 40, height: 30)
        view.addSubview(summaryLabel)
    }
}}