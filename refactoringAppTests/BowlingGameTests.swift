//
//  BowlingGameTests.swift
//  refactoringAppTests
//

import Testing
@testable import refactoringApp

struct BowlingGameTests {

    @Test func when_isRound10_then_isLastRoundShouldBeTrue() {
        let pairs = [(1, false), (2, false), (3, false), (4, false), (5, false), (6, false), (7, false), (8, false), (9, false), (10, true)]
        let sut = BowlingGame()
        pairs.forEach { (round, expectedResult) in
            sut.currentRound = round
            #expect(sut.isLastRound == expectedResult)
        }
    }

    @Test func when_roundScoreIsCreated_then_isCurrentRoundCreatedShouldBeTrue() {
        let sut = BowlingGame()
        sut.currentRound = 2
        sut.scores = [RoundScore(), RoundScore()]
        #expect(sut.isCurrentRoundScoreCreated)
    }

    @Test func when_roundScoreIsNotCreated_then_isCurrentRoundCreatedShouldBeFalse() {
        let sut = BowlingGame()
        sut.currentRound = 2
        sut.scores = [RoundScore()]
        #expect(!sut.isCurrentRoundScoreCreated)
    }

    @Test func when_advanceRoundIsCalled_then_currentRoundShouldBeIncrementedIn1() {
        let startRound = 2
        let sut = BowlingGame()
        sut.currentRound = startRound
        sut.advanceRound()
        #expect(sut.currentRound == startRound + 1)
    }

    @Test func when_resetIsCalled_then_currentRoundShouldBe1() {
        let sut = BowlingGame()
        sut.currentRound = 2
        sut.scores = [RoundScore(), RoundScore()]
        sut.reset()
        #expect(sut.currentRound == 1)
    }

}
