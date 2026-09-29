// View Controller for entering friends' names
import UIKit

class FriendEntryViewController: UIViewController {
    var friendsController: BowlingGameController?
    var tableView = UITableView()
    var addFriendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        addFriendButton.setTitle("Add Friend", for: .normal)
        addFriendButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        addFriendButton.frame = CGRect(x: 20, y: view.bounds.maxY - 50, width: view.bounds.width - 40, height: 50)
        view.addSubview(addFriendButton)
    }

    @objc func addFriend() {
        let alert = UIAlertController(title: "Add Friend", message: "Enter friend's name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                self?.friendsController?.addFriend(name: name)
            }
        })
        present(alert, animated: true)
    }
}}