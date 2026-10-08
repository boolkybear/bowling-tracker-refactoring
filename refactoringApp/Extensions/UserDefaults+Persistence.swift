//
//  UserDefaults+Persistence.swift
//  refactoringApp
//

import Foundation

protocol Persistence {
    func string(forKey: String) -> String?
    func setValue(_ value: Any?, forKey: String)
}

extension UserDefaults: Persistence {
}
