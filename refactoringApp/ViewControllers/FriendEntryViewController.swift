// View Controller for entering friends' names
import UIKit

class FriendEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var changeLanguageButton: UIBarButtonItem!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTranslations()
    }

    @IBAction @objc func addFriend() {
        let alert = UIAlertController(title: "Add Friend".localized, message: "Enter friend's name".localized, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name".localized
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "Add".localized, style: .default) { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                state.friends.append(name)
                self?.tableView.reloadData()
                if state.friends.count >= 10 {
                    self?.addButton.isEnabled = false
                }
                self?.startButton.isEnabled = true
            }
        })
        present(alert, animated: true)
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.friendLabel.text = state.friends[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    private func updateTranslations() {
        self.navigationItem.title = "Add friends".localized
        startButton.setTitle("Start game".localized, for: .normal)
        titleLabel.text = "Add up to 10 friends to this game".localized

        var language = persistence.string(forKey: "appLanguage") ?? "en"
        let validLanguages = ["es", "en"]
        if !validLanguages.contains(language) {
            language = "en"
        }
        let menu = UIMenu(title: "Change language".localized, options: [.singleSelection], children: [
            UIAction(title: "English".localized, state: language == "en" ? .on : .off) { [weak self] _ in
                persistence.setValue("en", forKey: "appLanguage")
                self?.updateTranslations()
            },
            UIAction(title: "Spanish".localized, state: language == "es" ? .on : .off) { [weak self] _ in
                persistence.setValue("es", forKey: "appLanguage")
                self?.updateTranslations()
            }
        ])
        changeLanguageButton.menu = menu
    }
}

extension FriendEntryViewController {
    @IBSegueAction func initializeRoundViewController(coder: NSCoder) -> RoundViewController {
        guard let viewController = RoundViewController(coder: coder) else {
            fatalError("RoundViewController not initialized")
        }
        viewController.state = state
        viewController.scoreCalculator = DefaultPendingScoreCalculator()
        return viewController
    }
}
