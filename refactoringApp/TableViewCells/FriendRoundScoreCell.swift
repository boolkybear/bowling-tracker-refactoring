//
//  FriendRoundScoreCell.swift
//  refactoringApp
//

import UIKit

class FriendRoundScoreCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FriendRoundScoreCell {
    func setCellContent(at index: Int, state: GameState, scoreCalculator: PendingScoreCalculator) {
        nameLabel.text = state.friends[index]
        if state.currentFriendTurnIndex <= index {
            scoreLabel.text = "Pending".localized + " " + "(\(scoreCalculator.calculateScore(game: state.game, friend: index)))".localized
            if index == state.currentFriendTurnIndex {
                accessoryType = .disclosureIndicator
            } else {
                accessoryType = .none
            }
        } else {
            let score = state.game.getCurrentRoundScoreForFriend(at: index)
            if scoreCalculator.isStrike(score) {
                scoreLabel.text = "10 + 2 next rolls".localized + " " + "(\(scoreCalculator.calculateScore(game: state.game, friend: index)))".localized
            } else if scoreCalculator.isSpare(score) {
                scoreLabel.text = "10 + next roll".localized + " " + "(\(scoreCalculator.calculateScore(game: state.game, friend: index)))".localized
            } else {
                let sum = scoreCalculator.getScoreSum(score)
                scoreLabel.text = "\(sum)" + " " + "(\(scoreCalculator.calculateScore(game: state.game, friend: index)))".localized
            }
            accessoryType = .checkmark
        }
    }
}
