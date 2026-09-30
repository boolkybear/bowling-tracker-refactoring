//
//  PinRollViewController.swift
//  refactoringApp
//
//  Created by Jose Servet Font on 28/09/2026.
//

import UIKit

class PinRollViewController: UIViewController {

    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var friendLabel: UILabel!
    @IBOutlet var pin1switch: UISwitch!
    @IBOutlet var pin2switch: UISwitch!
    @IBOutlet var pin3switch: UISwitch!
    @IBOutlet var pin4switch: UISwitch!
    @IBOutlet var pin5switch: UISwitch!
    @IBOutlet var pin6switch: UISwitch!
    @IBOutlet var pin7switch: UISwitch!
    @IBOutlet var pin8switch: UISwitch!
    @IBOutlet var pin9switch: UISwitch!
    @IBOutlet var pin10switch: UISwitch!
    @IBOutlet var roll1TitleLabel: UILabel!
    @IBOutlet var roll1Label: UILabel!
    @IBOutlet var roll1StrikeButton: UIButton!
    @IBOutlet var roll1CompleteButton: UIButton!
    @IBOutlet var roll2View: UIView!
    @IBOutlet var roll2TitleLabel: UILabel!
    @IBOutlet var roll2StrikeButton: UIButton!
    @IBOutlet var roll2CompleteButton: UIButton!
    @IBOutlet var roll2Label: UILabel!
    @IBOutlet var roll3View: UIView!
    @IBOutlet var roll3TitleLabel: UILabel!
    @IBOutlet var roll3StrikeButton: UIButton!
    @IBOutlet var roll3CompleteButton: UIButton!
    @IBOutlet var roll3Label: UILabel!
    @IBOutlet var finishFrameButton: UIButton!

    weak var previousViewController: RoundViewController?
    var scores: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTranslations()
        if game.scores.count == game.currentRound {
            friendLabel.text = friends[game.scores[game.currentRound - 1].friendsScores.count]
        } else {
            friendLabel.text = friends[0]
        }
        roll1Label.text = ""
        roll2View.isHidden = true
        roll3View.isHidden = true
        finishFrameButton.isEnabled = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction @objc func strike1() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        for pin in allSwitches {
            pin?.setOn(false, animated: true)
        }
        roll1Label.text = "10".localized
    }

    @IBAction @objc func complete1() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        var total = 0
        for pin in allSwitches {
            if let pin = pin {
                if !pin.isOn {
                    total += 1
                    pin.isEnabled = false
                }
            }
        }
        scores.append(total)
        roll1Label.text = "\(total)"
        roll1StrikeButton.isEnabled = false
        roll1CompleteButton.isEnabled = false
        if total == 10 {
            if game.currentRound == 10 {
                roll2View.isHidden = false
                roll2Label.text = ""
                roll2StrikeButton.setTitle("Strike".localized, for: .normal)
                for pin in allSwitches {
                    pin?.setOn(true, animated: true)
                    pin?.isEnabled = true
                }
            } else {
                finishFrameButton.isEnabled = true
            }
        } else {
            roll2View.isHidden = false
            roll2Label.text = ""
        }
    }

    @IBAction @objc func strike2() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        for pin in allSwitches {
            pin?.setOn(false, animated: true)
        }
        if game.currentRound == 10 {
            if scores[0] == 10 {
                roll2Label.text = "10".localized
            } else {
                let round = 10 - scores[0]
                roll2Label.text = "\(round)"
            }
        } else {
            let round = 10 - scores[0]
            roll2Label.text = "\(round)"
        }
    }

    @IBAction @objc func complete2() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        var total = 0
        for pin in allSwitches {
            if let pin = pin {
                if !pin.isOn {
                    total += 1
                    pin.isEnabled = false
                }
            }
        }
        var round = total
        if game.currentRound == 10 {
            if scores[0] != 10 {
                round -= scores[0]
            }
        } else {
            round -= scores[0]
        }
        scores.append(round)
        roll2Label.text = "\(round)"
        roll2StrikeButton.isEnabled = false
        roll2CompleteButton.isEnabled = false
        if game.currentRound == 10 {
            if scores[0] == 10 || scores[0] + scores[1] == 10 {
                roll3View.isHidden = false
                roll3Label.text = ""
                if scores[0] == 10 && scores[1] == 10 ||
                   (scores[0] != 10 && scores[0] + scores[1] == 10) {
                    roll3StrikeButton.setTitle("Strike".localized, for: .normal)
                    for pin in allSwitches {
                        pin?.setOn(true, animated: true)
                        pin?.isEnabled = true
                    }
                } else if scores[0] == 10, scores[1] < 10 {
                    roll3StrikeButton.setTitle("Spare".localized, for: .normal)
                }
            } else {
                finishFrameButton.isEnabled = true
            }
        } else {
            finishFrameButton.isEnabled = true
        }
    }

    @IBAction @objc func strike3() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        for pin in allSwitches {
            pin?.setOn(false, animated: true)
        }
        if scores[1] == 10 {
            roll3Label.text = "10".localized
        } else if scores[0] == 10 {
            let round = 10 - scores[1]
            roll3Label.text = "\(round)"
        }
    }

    @IBAction @objc func complete3() {
        let allSwitches = [pin1switch, pin2switch, pin3switch, pin4switch, pin5switch, pin6switch, pin7switch, pin8switch, pin9switch, pin10switch]
        var total = 0
        for pin in allSwitches {
            if let pin = pin {
                if !pin.isOn {
                    total += 1
                    pin.isEnabled = false
                }
            }
        }
        var round = total
        if scores[0] == 10, scores[1] != 10 {
            round -= scores[1]
        }
        scores.append(round)
        roll3Label.text = "\(round)"
        roll3StrikeButton.isEnabled = false
        roll3CompleteButton.isEnabled = false
        finishFrameButton.isEnabled = true
    }

    @IBAction @objc func finishFrame() {
        if game.scores.count < game.currentRound {
            game.scores.append(RoundScore())
        }
        let score = Score()
        score.scores = scores
        game.scores[game.currentRound - 1].friendsScores.append(score)

        previousViewController?.reloadScreen()
        dismiss(animated: true)
    }

    func updateTranslations() {
        roundLabel.text = "Round".localized + " " + "\(game.currentRound)"
        roll1TitleLabel.text = "Roll 1".localized
        roll1StrikeButton.setTitle("Strike".localized, for: .normal)
        roll1CompleteButton.setTitle("Complete".localized, for: .normal)
        roll2TitleLabel.text = "Roll 2".localized
        roll2StrikeButton.setTitle("Spare".localized, for: .normal)
        roll2CompleteButton.setTitle("Complete".localized, for: .normal)
        roll3TitleLabel.text = "Roll 3".localized
        roll3StrikeButton.setTitle("Strike".localized, for: .normal)
        roll3CompleteButton.setTitle("Complete".localized, for: .normal)
        finishFrameButton.setTitle("Finish frame".localized, for: .normal)
    }

}
