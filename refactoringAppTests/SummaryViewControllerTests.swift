//
//  SummaryViewControllerTests.swift
//  refactoringAppTests
//
//  Created by Jose Servet Font on 07/10/2026.
//

import Testing
@testable import refactoringApp
import UIKit

struct SummaryViewControllerTests {

    @MainActor
    @Test func when_viewIsLoaded_then_scoresShouldBeCalculated() throws {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyBoard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController else {
            throw CustomError.invalidViewController
        }
        let state = DefaultGameState()
        state.friends = ["Test 1", "Test 2"]
        state.game.currentRound = 10
        let finalRoundScore = RoundScore()
        let score1 = Score()
        score1.scores = [0, 1]
        let score2 = Score()
        score2.scores = [1, 2]
        finalRoundScore.friendsScores = [score1, score2]
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore, emptyScore]
        state.game.scores = [emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, finalRoundScore]
        sut.state = state
        sut.scoreCalculator = DefaultPendingScoreCalculator()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else  {
            throw CustomError.invalidWindowScene
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let friends = sut.sortedScores.map { $0.0 }
        let scores = sut.sortedScores.map { $0.1 }
        #expect(friends == ["Test 2", "Test 1"])
        #expect(scores == [3, 1])
    }

    @MainActor
    @Test func when_returnToFriendListIsCalled_then_gameShouldBeReset() async throws {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let sut = storyBoard.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController else {
            throw CustomError.invalidViewController
        }
        let state = DefaultGameState()
        state.friends = ["Test 1", "Test 2"]
        state.game.currentRound = 10
        let finalRoundScore = RoundScore()
        let score1 = Score()
        score1.scores = [0, 1]
        let score2 = Score()
        score2.scores = [1, 2]
        finalRoundScore.friendsScores = [score1, score2]
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore, emptyScore]
        state.game.scores = [emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, finalRoundScore]
        sut.state = state
        sut.scoreCalculator = DefaultPendingScoreCalculator()
        let dummyViewController = InstantDismissViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else  {
            throw CustomError.invalidWindowScene
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = dummyViewController
        window.makeKeyAndVisible()
        sut.modalPresentationStyle = .fullScreen
        dummyViewController.present(sut, animated: false)
        sut.returnToFriendList()
        try await Task.sleep(for: .milliseconds(500))
        let currentRound = state.game.currentRound
        #expect(currentRound == 1)
    }

}

extension SummaryViewControllerTests {
    enum CustomError: Error {
        case invalidViewController
        case invalidWindowScene
    }
}
