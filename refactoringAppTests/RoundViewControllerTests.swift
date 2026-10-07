//
//  RoundViewControllerTests.swift
//  refactoringAppTests
//

import Testing
@testable import refactoringApp
import UIKit

struct RoundViewControllerTests {

    let sut: RoundViewController
    let state: DefaultGameState

    @MainActor
    init() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyboard.instantiateViewController(withIdentifier: "RoundViewController") as? RoundViewController else {
            throw CustomError.invalidViewController
        }
        self.sut = sut
        state = DefaultGameState()
        sut.state = state
        sut.scoreCalculator = DefaultPendingScoreCalculator()
        state.friends = ["Test"]
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            throw CustomError.invalidWindowScene
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
    }

    @MainActor
    @Test func when_reloadScreenIsCalledAndIsLastRoundAndAllFriendsHaveShot_then_nextShouldNotBeEnabledAndFinishShouldBeEnabled() throws {
        state.game.currentRound = 10
        let finalRoundScore = RoundScore()
        let finalScore = Score()
        finalScore.scores = [1, 1]
        finalRoundScore.friendsScores = [finalScore]
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), finalRoundScore]
        sut.reloadScreen()
        #expect(!sut.nextButton.isEnabled)
        #expect(sut.finishButton.isEnabled)
    }

    @MainActor
    @Test func when_reloadScreenIsCalledAndIsLastRoundAndNotAllFriendsHaveShot_then_nextShouldNotBeEnabledAndFinishShouldNotBeEnabled() throws {
        state.game.currentRound = 10
        state.game.scores = [RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore(), RoundScore()]
        sut.reloadScreen()
        #expect(!sut.nextButton.isEnabled)
        #expect(!sut.finishButton.isEnabled)
    }

    @MainActor
    @Test func when_reloadScreenIsCalledAndIsNotLastRoundAndAllFriendsHaveShot_then_nextShouldBeEnabledAndFinishShouldNotBeEnabled() throws {
        state.game.currentRound = 1
        let finalRoundScore = RoundScore()
        let finalScore = Score()
        finalScore.scores = [1, 1]
        finalRoundScore.friendsScores = [finalScore]
        state.game.scores = [finalRoundScore]
        sut.reloadScreen()
        #expect(sut.nextButton.isEnabled)
        #expect(!sut.finishButton.isEnabled)
    }

    @MainActor
    @Test func when_reloadScreenIsCalledAndIsNotLastRoundAndNotAllFriendsHaveShot_then_nextShouldNotBeEnabledAndFinishShouldNotBeEnabled() throws {
        state.game.currentRound = 1
        state.game.scores = [RoundScore()]
        sut.reloadScreen()
        #expect(!sut.nextButton.isEnabled)
        #expect(!sut.finishButton.isEnabled)
    }

    @MainActor
    @Test func when_reloadScreenIsCalledAndIsNotLastRoundAndNoFriendsHaveShot_then_nextShouldNotBeEnabledAndFinishShouldNotBeEnabled() throws {
        state.game.currentRound = 1
        state.game.scores = [RoundScore()]
        sut.reloadScreen()
        #expect(!sut.nextButton.isEnabled)
        #expect(!sut.finishButton.isEnabled)
    }

    @MainActor
    @Test func when_goToNextRoundIsCalled_then_currentRoundShouldBeIncreased() throws {
        state.game.currentRound = 1
        sut.goToNextRound()
        #expect(state.game.currentRound == 2)
    }

    @MainActor
    @Test func when_numberOfRowsIsCalled_then_numberOfFriendsShouldBeReturned() throws {
        state.friends = ["Test 1", "Test 2"]
        let rowCount = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        #expect(rowCount == 2)
    }

    @MainActor
    @Test func when_cellForRowIsCalledForFirstFriendRollAndRoundIsNotCreated_then_accessoryTypeShouldBeDisclosureIndicator() throws {
        state.friends = ["Test 1", "Test 2"]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        #expect(cell.accessoryType == .disclosureIndicator)
    }

    @MainActor
    @Test func when_cellForRowIsCalledForFirstFriendRollAndRoundIsEmpty_then_accessoryTypeShouldBeDisclosureIndicator() throws {
        state.friends = ["Test 1", "Test 2"]
        state.game.scores = [RoundScore()]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        #expect(cell.accessoryType == .disclosureIndicator)
    }

    @MainActor
    @Test func when_cellForRowIsCalledForSecondFriendRoll_then_accessoryTypeShouldBeNone() throws {
        state.friends = ["Test 1", "Test 2"]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        #expect(cell.accessoryType == .none)
    }

    @MainActor
    @Test func when_cellForRowIsCalledForSecondFriendRollAndFirstFriendAlreadyRolled_then_accessoryTypeShouldBeDisclosureIndicator() throws {
        state.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [10]
        roundScore.friendsScores = [score]
        state.game.scores = [roundScore]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        #expect(cell.accessoryType == .disclosureIndicator)
    }

    @MainActor
    @Test func when_cellForRowIsCalledForFirstFriendAndFirstFriendAlreadyRolled_then_accessoryTypeShouldBeCheckmark() throws {
        state.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [10]
        roundScore.friendsScores = [score]
        state.game.scores = [roundScore]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        #expect(cell.accessoryType == .checkmark)
    }

}

private extension RoundViewControllerTests {
    enum CustomError: Error {
        case invalidViewController
        case invalidWindowScene
    }
}
