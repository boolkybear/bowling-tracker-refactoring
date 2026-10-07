//
//  DefaultGameStateTests.swift
//  refactoringAppTests
//
//  Created by Jose Servet Font on 07/10/2026.
//

import Testing
@testable import refactoringApp

struct DefaultGameStateTests {

    @MainActor
    @Test func when_allFriendsHaveRolled_then_isCurrentRoundFinishedForAllFriendsShouldBeTrue() {
        let sut = DefaultGameState()
        sut.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [1, 2]
        roundScore.friendsScores = [score, score]
        sut.game.scores = [roundScore]
        #expect(sut.isCurrentRoundFinishedForAllFriends)
    }

    @MainActor
    @Test func when_notAllFriendsHaveRolled_then_isCurrentRoundFinishedForAllFriendsShouldBeFalse() {
        let sut = DefaultGameState()
        sut.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [1, 2]
        roundScore.friendsScores = [score]
        sut.game.scores = [roundScore]
        #expect(!sut.isCurrentRoundFinishedForAllFriends)
    }

    @MainActor
    @Test func when_allFriendsHaveRolled_then_currentFriendTurnIndexShouldMatchNumberOfFriends() {
        let sut = DefaultGameState()
        sut.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [1, 2]
        roundScore.friendsScores = [score, score]
        sut.game.scores = [roundScore]
        #expect(sut.currentFriendTurnIndex == 2)
    }

    @MainActor
    @Test func when_notAllFriendsHaveRolled_then_currentFriendTurnIndexShouldMatchNumberOfFriendsThatHaveRolled() {
        let sut = DefaultGameState()
        sut.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [1, 2]
        roundScore.friendsScores = [score]
        sut.game.scores = [roundScore]
        #expect(sut.currentFriendTurnIndex == 1)
    }

    @MainActor
    @Test func when_noFriendsHaveRolled_then_currentFriendTurnIndexShouldBe0() {
        let sut = DefaultGameState()
        sut.friends = ["Test 1", "Test 2"]
        let roundScore = RoundScore()
        let score = Score()
        score.scores = [1, 2]
        roundScore.friendsScores = []
        sut.game.scores = [roundScore]
        #expect(sut.currentFriendTurnIndex == 0)
    }

}
