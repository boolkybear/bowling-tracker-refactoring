//
//  RoundViewController.swift
//  refactoringApp
//

import UIKit

class RoundViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var finishButton: UIButton!

    var state: GameState?
    var scoreCalculator: PendingScoreCalculator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTranslations()
        reloadScreen()
    }

    func reloadScreen() {
        guard let state else {
            return
        }

        roundLabel.text = "Round".localized + " " + "\(state.game.currentRound)"
        tableView.reloadData()
        if state.game.isLastRound {
            nextButton.isEnabled = false
            if state.isCurrentRoundFinishedForAllFriends {
                finishButton.isEnabled = true
            }
        } else {
            nextButton.isEnabled = state.isCurrentRoundFinishedForAllFriends
        }
    }

    @IBAction @objc func goToNextRound() {
        guard let state else {
            return
        }

        state.game.advanceRound()
        reloadScreen()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let state else {
            return 0
        }

        return state.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let state,
              let scoreCalculator,
              let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRoundScoreCell") as? FriendRoundScoreCell else {
            return UITableViewCell()
        }
        cell.setCellContent(at: indexPath.row, state: state, scoreCalculator: scoreCalculator)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let state,
              indexPath.row == state.currentFriendTurnIndex else {
            return
        }

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
            return
        }
        vc.previousViewController = self
        vc.state = state
        present(vc, animated: true)
    }

    func updateTranslations() {
        nextButton.setTitle("Next round".localized, for: .normal)
        finishButton.setTitle("Finish game".localized, for: .normal)
    }

}

extension RoundViewController: ScreenReloadable {}

extension RoundViewController {
    @IBSegueAction func initializeSummaryViewController(coder: NSCoder) -> SummaryViewController {
        guard let viewController = SummaryViewController(coder: coder) else {
            fatalError("SummaryViewController not initialized")
        }
        viewController.state = state
        viewController.scoreCalculator = DefaultPendingScoreCalculator()
        return viewController
    }
}
