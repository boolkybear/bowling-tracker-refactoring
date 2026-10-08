//
//  PinRollViewControllerTests.swift
//  refactoringAppTests
//
//  Created by Jose Servet Font on 05/10/2026.
//

import Testing
@testable import refactoringApp
import UIKit

struct PinRollViewControllerTests {

    let sut: PinRollViewController
    let state: DefaultGameState
    let windowScene: UIWindowScene

    @MainActor
    init() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "PinRollViewController") as? PinRollViewController else {
            throw CustomError.invalidViewControllerType
        }
        state = DefaultGameState()
        state.friends = ["Test"]
        sut.state = state
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw CustomError.invalidWindowScene
        }
        self.sut = sut
        self.windowScene = windowScene
    }

    @MainActor
    @Test func when_viewIsLoaded_then_viewsShouldBeInitialized() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        #expect(sut.friendLabel.text == "Test")
        #expect(sut.roll1Label.text == "")
        #expect(sut.roll2View.isHidden)
        #expect(sut.roll3View.isHidden)
        #expect(!sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_viewIsLoadedInCurrentRound_then_viewsShouldBeInitialized() throws {
        state.game.scores = [RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        #expect(sut.friendLabel.text == "Test")
        #expect(sut.roll1Label.text == "")
        #expect(sut.roll2View.isHidden)
        #expect(sut.roll3View.isHidden)
        #expect(!sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_strike1IsCalled_then_allPinsShouldBeFalse() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        sut.strike1()
        let areAllFalse = pins.allSatisfy { !$0.isOn }
        #expect(areAllFalse)
    }

    @MainActor
    @Test func when_complete1IsCalledAndIsNotStrike_then_scoresShouldBeUpdatedAndRoll1ViewsShouldBeDisabledAndRoll2ViewsShouldBeVisible() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.complete1()
        #expect(sut.scores == [2])
        #expect(!sut.roll1StrikeButton.isEnabled)
        #expect(!sut.roll1CompleteButton.isEnabled)
        #expect(!sut.roll2View.isHidden)
    }

    @MainActor
    @Test func when_complete1IsCalledAndIsStrikeInLastRound_then_scoresShouldBeUpdatedAndRoll1ViewsShouldBeDisabledAndAllPinsShouldBeEnabled() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.complete1()
        let arePinsEnabled = pins.allSatisfy { $0.isOn }
        #expect(sut.scores == [10])
        #expect(!sut.roll1StrikeButton.isEnabled)
        #expect(!sut.roll1CompleteButton.isEnabled)
        #expect(!sut.roll2View.isHidden)
        #expect(arePinsEnabled)
    }

    @MainActor
    @Test func when_complete1IsCalledAndIsStrikeInIntermediateRound_then_scoresShouldBeUpdatedAndRoll1ViewsShouldBeDisabledAndAllPinsShouldBeEnabled() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.complete1()
        #expect(sut.scores == [10])
        #expect(!sut.roll1StrikeButton.isEnabled)
        #expect(!sut.roll1CompleteButton.isEnabled)
        #expect(sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_strike2IsCalled_then_allPinsShouldBeFalse() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        sut.scores = [0]
        sut.strike2()
        let areAllFalse = pins.allSatisfy { !$0.isOn }
        #expect(areAllFalse)
    }

    @MainActor
    @Test func when_complete2IsCalledAndIsNotLastRound_then_finishFrameButtonShouldBeEnabled() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.scores = [0]
        sut.complete2()
        #expect(sut.scores == [0, 2])
        #expect(sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_complete2IsCalledAndIsLastRoundAndRoll2IsStrike_then_roll3ViewsShouldBeVisible() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.scores = [10]
        sut.complete2()
        #expect(sut.scores == [10, 10])
        #expect(!sut.roll3View.isHidden)
    }

    @MainActor
    @Test func when_complete2IsCalledAndIsLastRoundAndRoll1IsSpare_then_roll3ViewsShouldBeVisible() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.scores = [8]
        sut.complete2()
        #expect(sut.scores == [8, 2])
        #expect(!sut.roll3View.isHidden)
    }

    @MainActor
    @Test func when_complete2IsCalledAndIsLastRoundAndRoll1IsNotStrikeNorSpare_then_roll3ViewsShouldBeVisible() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.scores = [0]
        sut.complete2()
        #expect(sut.scores == [0, 2])
        #expect(sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_strike3IsCalled_then_allPinsShouldBeFalse() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        sut.scores = [10, 10]
        sut.strike3()
        let areAllFalse = pins.allSatisfy { !$0.isOn }
        #expect(areAllFalse)
    }

    @MainActor
    @Test func when_complete3IsCalled_then_finishFrameButtonShouldBeEnabled() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let pins = [sut.pin1switch, sut.pin2switch, sut.pin3switch, sut.pin4switch, sut.pin5switch, sut.pin6switch, sut.pin7switch, sut.pin8switch, sut.pin9switch, sut.pin10switch].compactMap { $0 }
        guard !pins.isEmpty else {
            throw CustomError.noPins
        }
        pins.forEach { $0.isOn = false }
        sut.scores = [10, 10]
        sut.complete3()
        #expect(sut.scores == [10, 10, 10])
        #expect(sut.finishFrameButton.isEnabled)
    }

    @MainActor
    @Test func when_finishFrameIsCalled_then_scoreShouldBeSet() throws {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.scores = [10]
        sut.finishFrame()
        #expect(state.game.scores[0].friendsScores[0].scores == [10])
    }

    @MainActor
    @Test func when_finishFrameIsCalled_then_screenShouldBeReloaded() throws {
        let delegate = ScreenReloadableSpy()
        sut.previousViewController = delegate
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.scores = [10]
        sut.finishFrame()
        #expect(delegate.isCalledReloadScreen)
    }

}

extension PinRollViewControllerTests {
    enum CustomError: Error {
        case invalidViewControllerType
        case invalidWindowScene
        case noPins
    }
}
