//
//  FriendScoreCell.swift
//  refactoringApp
//
//  Created by Jose Servet Font on 28/09/2026.
//

import UIKit

class FriendScoreCell: UITableViewCell {

    @IBOutlet var positionLabel: UILabel!
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
