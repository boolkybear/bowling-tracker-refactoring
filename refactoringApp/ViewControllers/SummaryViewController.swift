// View Controller for the summary screen
import UIKit

class SummaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var sortedScores: [(String, Int)] = []

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTranslations()

        var scores: [Int] = []
        var index = 0
        for _ in friends {
            var total = 0
            for round in (0..<10) {
                if round == 9 {
                    let score = game.scores[round].friendsScores[index]
                    let sum = score.scores.reduce(0, +)
                    total += sum
                } else {
                    let score = game.scores[round].friendsScores[index]
                    var sum = score.scores.reduce(0, +)
                    if sum == 10 {
                        var nextRolls: [Int] = []
                        let nextRound = round + 1
                        for next in (nextRound..<10) {
                            nextRolls.append(contentsOf: game.scores[next].friendsScores[index].scores)
                        }
                        sum += nextRolls[0]
                        if score.scores.count == 1 {
                            sum += nextRolls[1]
                        }
                        total += sum
                    } else {
                        total += sum
                    }
                }
            }
            scores.append(total)
            index += 1
        }
        let pairs = zip(friends, scores)
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

        let colors: [UIColor] = [.green, .yellow, .orange, .red, .red, .red, .red, .red, .red, .red]

        cell.positionLabel.text = "\(indexPath.row + 1)"
        cell.nameLabel.text = sortedScores[indexPath.row].0
        cell.scoreLabel.text = "\(sortedScores[indexPath.row].1)"
        cell.backgroundColorView.backgroundColor = colors[indexPath.row]
        cell.contentView.backgroundColor = colors[indexPath.row].withAlphaComponent(0.2)

        return cell
    }

    @IBAction @objc func returnToFriendList() {
        let parentViewController = presentingViewController?.presentingViewController ?? presentingViewController ?? self
        parentViewController.dismiss(animated: true) {
            game.currentRound = 1
            game.scores = []
        }
    }

    func updateTranslations() {
        titleLabel.text = "Game finished".localized
        playAgainButton.setTitle("Play again".localized, for: .normal)
    }
}
