// Model for the bowling game
import Foundation

class BowlingGame {
    var scores: [RoundScore] = []
    var currentRound = 1
}

class Score {
    var scores: [Int] = []
}

class RoundScore {
    var friendsScores: [Score] = []
}

extension BowlingGame {
    var isLastRound: Bool {
        currentRound == 10
    }
}
