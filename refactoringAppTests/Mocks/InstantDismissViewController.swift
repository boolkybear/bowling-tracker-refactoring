//
//  InstantDismissViewController.swift
//  refactoringApp
//

import UIKit

final class InstantDismissViewController: UIViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: false, completion: completion)
    }
}
