// View Controller for the summary screen
import UIKit

class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var sortedScores: [(String, Int)] = []

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playAgainButton: UIButton!

    var state: GameState?
    var scoreCalculator: PendingScoreCalculator?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let state,
              let scoreCalculator else {
            return
        }

        updateTranslations()

        let scores = state.friends.enumerated().map { (index, _) in
            return scoreCalculator.calculateScore(game: state.game, friend: index)
        }
        let pairs = zip(state.friends, scores)
        sortedScores = pairs.sorted(by: { return $0.1 < $1.1 }).reversed()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendScoreCell") as? FriendScoreCell else {
            return UITableViewCell()
        }

        let name = sortedScores[indexPath.row].0
        let score = sortedScores[indexPath.row].1
        cell.setCellContent(at: indexPath.row, name: name, score: score)

        return cell
    }

    @IBAction @objc func returnToFriendList() {
        guard let state else {
            return
        }
        let parentViewController = presentingViewController?.presentingViewController ?? presentingViewController ?? self
        parentViewController.dismiss(animated: true) {
            state.game.reset()
        }
    }

    func updateTranslations() {
        titleLabel.text = "Game finished".localized
        playAgainButton.setTitle("Play again".localized, for: .normal)
    }
}
