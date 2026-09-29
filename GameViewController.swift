// View Controller for the game screen
import UIKit

class GameViewController: UIViewController {
    var bowlingGameController: BowlingGameController?
    var roundLabel = UILabel()
    var playerLabel = UILabel()
    var rollButton1 = UIButton()
    var rollButton2 = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        roundLabel.text = "Round 1"
        roundLabel.frame = CGRect(x: 20, y: 50, width: view.bounds.width - 40, height: 30)
        view.addSubview(roundLabel)

        playerLabel.text = "Player:"
        playerLabel.frame = CGRect(x: 20, y: roundLabel.frame.maxY + 20, width: view.bounds.width - 40, height: 30)
        view.addSubview(playerLabel)

        rollButton1.setTitle("Roll 1", for: .normal)
        rollButton1.addTarget(self, action: #selector(roll1), for: .touchUpInside)
        rollButton1.frame = CGRect(x: 20, y: playerLabel.frame.maxY + 20, width: view.bounds.width / 2 - 30, height: 50)
        view.addSubview(rollButton1)

        rollButton2.setTitle("Roll 2", for: .normal)
        rollButton2.addTarget(self, action: #selector(roll2), for: .touchUpInside)
        rollButton2.frame = CGRect(x: view.bounds.width / 2 + 30, y: playerLabel.frame.maxY + 20, width: view.bounds.width / 2 - 30, height: 50)
        view.addSubview(rollButton2)
    }

    @objc func roll1() {
        let pins = Int.random(in: 0...10)
        bowlingGameController?.recordRoll(pins: pins, rollNumber: 1)
    }

    @objc func roll2() {
        let pins = Int.random(in: 0...10)
        bowlingGameController?.recordRoll(pins: pins, rollNumber: 2)
    }
}}