//
//  ScreenReloadableSpy.swift
//  refactoringApp
//

@testable import refactoringApp

final class ScreenReloadableSpy: ScreenReloadable {
    private(set) var isCalledReloadScreen = false

    func reloadScreen() {
        isCalledReloadScreen = true
    }

}
