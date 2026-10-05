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
}
