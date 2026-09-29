//
//  RoundViewController.swift
//  refactoringApp
//
//  Created by Jose Servet Font on 28/09/2026.
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
        reloadScreen()
    }

    func reloadScreen() {
        roundLabel.text = "Round \(game.currentRound)"
        tableView.reloadData()
        if game.currentRound == 10 {
            nextButton.isEnabled = false
            finishButton.isEnabled = true
        } else {
            if game.scores.count == game.currentRound {
                if game.scores[game.currentRound - 1].friendsScores.count == friends.count {
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
        game.currentRound += 1
        reloadScreen()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRoundScoreCell") as? FriendRoundScoreCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = friends[indexPath.row]
        if game.scores.count < game.currentRound {
            cell.scoreLabel.text = "Pending" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))"
            if indexPath.row == 0 {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        } else {
            if game.scores[game.currentRound - 1].friendsScores.count <= indexPath.row {
                cell.scoreLabel.text = "Pending" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))"
                if indexPath.row == game.scores[game.currentRound - 1].friendsScores.count {
                    cell.accessoryType = .disclosureIndicator
                } else if indexPath.row < game.scores[game.currentRound - 1].friendsScores.count {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .checkmark
                }
            } else {
                let score = game.scores[game.currentRound - 1].friendsScores[indexPath.row]
                let sum = score.scores.reduce(0, +)
                if sum == 10 {
                    if score.scores.count == 1 {
                        cell.scoreLabel.text = "10 + 2 next rolls" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))"
                    } else {
                        cell.scoreLabel.text = "10 + next roll" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))"
                    }
                } else {
                    cell.scoreLabel.text = "\(sum)" + " " + "(\(PendingScoreCalculator.calculateScore(friend: indexPath.row)))"
                }
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if game.scores.count < game.currentRound {
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
            if indexPath.row == game.scores[game.currentRound - 1].friendsScores.count {
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

}
