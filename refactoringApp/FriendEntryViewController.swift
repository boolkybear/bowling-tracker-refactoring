// View Controller for entering friends' names
import UIKit

class FriendEntryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var startButton: UIButton!

    @IBAction @objc func addFriend() {
        let alert = UIAlertController(title: "Add Friend", message: "Enter friend's name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                friends.append(name)
                self?.tableView.reloadData()
                if friends.count >= 10 {
                    self?.addButton.isEnabled = false
                }
                self?.startButton.isEnabled = true
            }
        })
        present(alert, animated: true)
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.friendLabel.text = friends[indexPath.row]
        return cell
    }
}
