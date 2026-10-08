//
//  FriendScoreCell.swift
//  refactoringApp
//

import UIKit

class FriendScoreCell: UITableViewCell {

    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var backgroundColorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FriendScoreCell {
    func setCellContent(at index: Int, name: String, score: Int) {
        let colors: [UIColor] = [.green, .yellow, .orange, .red, .red, .red, .red, .red, .red, .red]

        positionLabel.text = "\(index + 1)"
        nameLabel.text = name
        scoreLabel.text = "\(score)"
        backgroundColorView.backgroundColor = colors[index]
        contentView.backgroundColor = colors[index].withAlphaComponent(0.2)
    }
}
