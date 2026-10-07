//
//  PendingScoreCalculatorTests.swift
//  refactoringAppTests
//
//  Created by Jose Servet Font on 05/10/2026.
//

import Testing
@testable import refactoringApp

struct PendingScoreCalculatorTests {

    @MainActor
    @Test func when_scoreIsEmpty_then_sumShouldBeZero() {
        let score = Score()
        let sum = PendingScoreCalculator.getScoreSum(score)
        #expect(sum == 0)
    }

    @MainActor
    @Test func when_scoreIsNotEmpty_then_sumShouldBeTheSumOfScores() {
        let score = Score()
        score.scores = [10, 20, 30]
        let sum = PendingScoreCalculator.getScoreSum(score)
        #expect(sum == 60)
    }

    @Test func when_scoreHasOneRollAndIs10_then_itShouldBeStrike() {
        let score = Score()
        score.scores = [10]
        let isStrike = PendingScoreCalculator.isStrike(score)
        #expect(isStrike)
    }

    @Test func when_scoreHasOneRollAndIsNot10_then_itShouldNotBeStrike() {
        let score = Score()
        score.scores = [8]
        let isStrike = PendingScoreCalculator.isStrike(score)
        #expect(!isStrike)
    }

    @Test func when_scoreHasMoreThanOneRollAndIs10_then_itShouldNotBeStrike() {
        let score = Score()
        score.scores = [8, 2]
        let isStrike = PendingScoreCalculator.isStrike(score)
        #expect(!isStrike)
    }

    @Test func when_scoreHasTwoRollsAndIs10_then_itShouldBeSpare() {
        let score = Score()
        score.scores = [8, 2]
        let isSpare = PendingScoreCalculator.isSpare(score)
        #expect(isSpare)
    }

    @Test func when_scoreHasTwoRollsAndIsNot10_then_itShouldNotBeSpare() {
        let score = Score()
        score.scores = [1, 2]
        let isSpare = PendingScoreCalculator.isSpare(score)
        #expect(!isSpare)
    }

    @Test func when_scoreHasOneRollAndIs10_then_itShouldNotBeSpare() {
        let score = Score()
        score.scores = [10]
        let isSpare = PendingScoreCalculator.isSpare(score)
        #expect(!isSpare)
    }

    @Test func when_scoresHaveNotStrikesOrSpares_then_scoreShouldBeTheSum() {
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [0, 1]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 3
        game.scores = [emptyRoundScore, pointsRoundScore, RoundScore()]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 1)
    }

    @Test func when_gameIsNotCompleteAndLastFrameIsAStrike_then_nextRollsShouldNotBeAdded() {
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [10]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 2
        game.scores = [emptyRoundScore, pointsRoundScore]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 10)
    }

    @Test func when_gameIsNotCompleteAndLastFrameIsASpare_then_nextRollsShouldNotBeAdded() {
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [2, 8]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 2
        game.scores = [emptyRoundScore, pointsRoundScore]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 10)
    }

    @Test func when_gameIsNotCompleteAndHasAStrike_then_nextTwoRollsShouldBeAdded() {
        let strikeRoundScore = RoundScore()
        let strikeScore = Score()
        strikeScore.scores = [10]
        strikeRoundScore.friendsScores = [strikeScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [1, 1]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 2
        game.scores = [strikeRoundScore, pointsRoundScore]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 12 + 2)
    }

    @Test func when_gameIsNotCompleteAndHasASpare_then_nextRollShouldBeAdded() {
        let spareRoundScore = RoundScore()
        let spareScore = Score()
        spareScore.scores = [8, 2]
        spareRoundScore.friendsScores = [spareScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [1, 1]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 2
        game.scores = [spareRoundScore, pointsRoundScore]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 11 + 2)
    }

    @Test func when_gameIsComplete_then_lastFrameScoreShouldBeTheSumOfAllRolls() {
        let emptyRoundScore = RoundScore()
        let emptyScore = Score()
        emptyScore.scores = [0, 0]
        emptyRoundScore.friendsScores = [emptyScore]
        let pointsRoundScore = RoundScore()
        let pointsScore = Score()
        pointsScore.scores = [10, 8, 2]
        pointsRoundScore.friendsScores = [pointsScore]
        let game = BowlingGame()
        game.currentRound = 10
        game.scores = [emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, emptyRoundScore, pointsRoundScore]
        let score = PendingScoreCalculator.calculateScore(game: game, friend: 0)
        #expect(score == 20)
    }
}
