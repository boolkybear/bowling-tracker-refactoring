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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTranslations()
        reloadScreen()
    }

    func reloadScreen() {
        roundLabel.text = "Round".localized + " " + "\(state.game.currentRound)"
        tableView.reloadData()
        if state.game.currentRound == 10 {
            nextButton.isEnabled = false
            if state.game.scores.count == state.game.currentRound,
               state.game.scores[state.game.currentRound - 1].friendsScores.count == state.friends.count {
                finishButton.isEnabled = true
            }
        } else {
            if state.game.scores.count == state.game.currentRound {
                if state.game.scores[state.game.currentRound - 1].friendsScores.count == state.friends.count {
                    nextButton.isEnabled = true
                } else {
                    nextButton.isEnabled = false
                }
            } else {
                nextButton.isEnabled = false
            }
        }
    }

    @IBAction @objc func goToNextRound() {
        state.game.currentRound += 1
        reloadScreen()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRoundScoreCell") as? FriendRoundScoreCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = state.friends[indexPath.row]
        if state.game.scores.count < state.game.currentRound {
            cell.scoreLabel.text = "Pending".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        } else {
            if state.game.scores[state.game.currentRound - 1].friendsScores.count <= indexPath.row {
                cell.scoreLabel.text = "Pending".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                if indexPath.row == state.game.scores[state.game.currentRound - 1].friendsScores.count {
                    cell.accessoryType = .disclosureIndicator
                } else if indexPath.row < state.game.scores[state.game.currentRound - 1].friendsScores.count {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                let score = state.game.scores[state.game.currentRound - 1].friendsScores[indexPath.row]
                let sum = score.scores.reduce(0, +)
                if sum == 10 {
                    if score.scores.count == 1 {
                        cell.scoreLabel.text = "10 + 2 next rolls".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                    } else {
                        cell.scoreLabel.text = "10 + next roll".localized + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                    }
                } else {
                    cell.scoreLabel.text = "\(sum)" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))".localized
                }
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if state.game.scores.count < state.game.currentRound {
            if indexPath.row == 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
                    return
                }
                vc.previousViewController = self
                present(vc, animated: true)
            } else {
                return
            }
        } else {
            if indexPath.row == state.game.scores[state.game.currentRound - 1].friendsScores.count {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
                    return
                }
                vc.previousViewController = self
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
