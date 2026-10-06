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
            if state.game.isCurrentRoundScoreCreated,
               state.isCurrentRoundFinishedForAllFriends {
                finishButton.isEnabled = true
            }
        } else {
            if state.game.isCurrentRoundScoreCreated {
                nextButton.isEnabled = state.isCurrentRoundFinishedForAllFriends
            } else {
                nextButton.isEnabled = false
            }
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
              let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRoundScoreCell") as? FriendRoundScoreCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = state.friends[indexPath.row]
        if !state.game.isCurrentRoundScoreCreated {
            cell.scoreLabel.text = "Pending".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        } else {
            if state.currentFriendTurnIndex <= indexPath.row {
                cell.scoreLabel.text = "Pending".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                if indexPath.row == state.currentFriendTurnIndex {
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.accessoryType = .none
                }
            } else {
                let score = state.game.scores[state.game.currentRound - 1].friendsScores[indexPath.row]
                if PendingScoreCalculator.isStrike(score) {
                    cell.scoreLabel.text = "10 + 2 next rolls".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                } else if PendingScoreCalculator.isSpare(score) {
                    cell.scoreLabel.text = "10 + next roll".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                } else {
                    let sum = PendingScoreCalculator.getScoreSum(score)
                    cell.scoreLabel.text = "\(sum)" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                }
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let state else {
            return
        }

        if !state.game.isCurrentRoundScoreCreated {
            if indexPath.row == 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
                    return
                }
                vc.previousViewController = self
                vc.state = state
                present(vc, animated: true)
            } else {
                return
            }
        } else {
            if indexPath.row == state.currentFriendTurnIndex {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
                    return
                }
                vc.previousViewController = self
                vc.state = state
                present(vc, animated: true)
            } else {
                return
            }
        }
    }

    func updateTranslations() {
        nextButton.setTitle("Next round".localized, for: .normal)
        finishButton.setTitle("Finish game".localized, for: .normal)
    }

}

extension RoundViewController: ScreenReloadable {}
