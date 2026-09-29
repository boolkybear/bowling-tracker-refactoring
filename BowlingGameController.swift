// Controller for managing the bowling game logic
import UIKit

class BowlingGameController: NSObject, UITableViewDataSource, UITableViewDelegate {
    var bowlingGame = BowlingGame()
    weak var friendEntryViewController: FriendEntryViewController?
    weak var gameViewController: GameViewController?
    weak var summaryViewController: SummaryViewController?

    func addFriend(name: String) {
        bowlingGame.friends.append(name)
        friendEntryViewController?.tableView.reloadData()
    }

    func recordRoll(pins: Int, rollNumber: Int) {
        var rolls = bowlingGame.scores.last ?? []
        if rollNumber == 1 {
            rolls.append(pins)
        } else {
            rolls.append(pins)
            bowlingGame.scores.append(rolls)
        }
    }

    // UITableViewDataSource and UITableViewDelegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bowlingGame.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bowlingGame.friends[indexPath.row]
        return cell
    }
}}